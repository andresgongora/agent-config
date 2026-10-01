#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

##==================================================================================================
##	DEPENDENCY CHECKS
##==================================================================================================

requireCommand() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$1" >&2
        exit 1
    fi
}

requireCommand find
requireCommand sort
requireCommand python3

##==================================================================================================
##	GLOBALS
##==================================================================================================

declare -r SCRIPT_NAME="${0##*/}"
declare -a INPUT_FILES=()
declare -a SKIPPED_TOOLS=()
declare -a WARNINGS=()
declare -A SKIPPED_TOOL_SET=()

##==================================================================================================
##	UTILITIES
##==================================================================================================

die() {
    printf '%s: %s\n' "$SCRIPT_NAME" "$1" >&2
    exit 1
}

printUsage() {
    printf 'Usage: %s <file.md>\n       %s --recursive <directory>\n' \
        "$SCRIPT_NAME" "$SCRIPT_NAME"
}

recordSkippedTool() {
    local tool_name="$1"
    if [[ -z "${SKIPPED_TOOL_SET[$tool_name]:-}" ]]; then
        SKIPPED_TOOLS+=("$tool_name")
        SKIPPED_TOOL_SET["$tool_name"]=true
    fi
}

##--------------------------------------------------------------------------------------------------

runCheck() {
    local check_name="$1"
    shift
    local output
    if ! output="$("$@" 2>&1)"; then
        printf 'FAIL check=%s\n%s\n' "$check_name" "$output" >&2
        return 1
    fi
}

##==================================================================================================
##	CORE FUNCTIONS
##==================================================================================================

getMarkdownFiles() {
    local directory_path="$1"
    local file_path
    local -a markdown_files=()
    while IFS= read -r -d '' file_path; do
        markdown_files+=("$file_path")
    done < <(find "$directory_path" -type f -name '*.md' -print0 | sort -z)
    ((${#markdown_files[@]} > 0)) || die "No .md files found under: $directory_path"
    INPUT_FILES+=("${markdown_files[@]}")
}

resolveMarkdownlintConfig() {
    local file_path="$1"
    local search_directory
    local config_name
    search_directory="$(cd "$(dirname "$file_path")" && pwd -P)"
    while :; do
        for config_name in .markdownlint-cli2.jsonc .markdownlint-cli2.yaml \
            .markdownlint-cli2.yml .markdownlint-cli2.json .markdownlint.jsonc \
            .markdownlint.yaml .markdownlint.yml .markdownlint.json; do
            if [[ -f "$search_directory/$config_name" ]]; then
                printf '%s\n' "$search_directory/$config_name"
                return
            fi
        done
        [[ "$search_directory" != / ]] || break
        search_directory="$(dirname "$search_directory")"
    done
    if [[ -f "$HOME/.markdownlint.jsonc" ]]; then
        printf '%s\n' "$HOME/.markdownlint.jsonc"
    fi
}

##--------------------------------------------------------------------------------------------------

formatDecorators() {
    local file_path="$1"
    python3 - "$file_path" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text()
lines = text.splitlines(keepends=True)
decorator = re.compile(r"^<!-{10,}>\s*(?:\r?\n)?$")
index = 0
while index < len(lines):
    if not decorator.match(lines[index]):
        index += 1
        continue
    while index > 0 and lines[index - 1].strip() == "":
        del lines[index - 1]
        index -= 1
    while index + 1 < len(lines) and lines[index + 1].strip() == "":
        del lines[index + 1]
    index += 1
path.write_text("".join(lines))
PY
}

##--------------------------------------------------------------------------------------------------

checkMarkdownlint() {
    local file_path="$1"
    local markdownlint_config
    if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
        recordSkippedTool markdownlint-cli2
        printf 'SKIP markdownlint-cli2: unavailable\n'
        return
    fi
    markdownlint_config="$(resolveMarkdownlintConfig "$file_path")"
    if [[ -n "$markdownlint_config" ]]; then
        runCheck markdownlint-cli2 markdownlint-cli2 --fix --config \
            "$markdownlint_config" -- "$file_path"
    else
        runCheck markdownlint-cli2 markdownlint-cli2 --fix -- "$file_path"
    fi
}

##--------------------------------------------------------------------------------------------------

checkPrettier() {
    local file_path="$1"
    if ! command -v prettier >/dev/null 2>&1; then
        recordSkippedTool prettier
        printf 'SKIP prettier: unavailable\n'
        return
    fi
    runCheck prettier prettier --check -- "$file_path"
}

##--------------------------------------------------------------------------------------------------

checkFrontmatter() {
    local file_path="$1"
    if ! command -v yq >/dev/null 2>&1; then
        recordSkippedTool yq
        printf 'SKIP yq: frontmatter check unavailable\n'
        return
    fi
    local output
    if ! output="$(awk 'NR==1{if($0!="---")exit 2;next}/^---$/{exit 0}{print}' \
        "$file_path" | yq -e 'type == "!!map"' 2>&1)"; then
        printf 'FAIL check=frontmatter file=%s\n%s\n' "$file_path" "$output" >&2
        return 1
    fi
}

##--------------------------------------------------------------------------------------------------

analyzeStructure() {
    local file_path="$1"
    local report
    local report_line
    report="$(
        python3 - "$file_path" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text()
path = Path(sys.argv[1])

def removeCodeFences(markdown):
    lines = []
    fence_character = None
    fence_length = 0
    for line in markdown.splitlines():
        match = re.match(r"^\s*(`{3,}|~{3,})", line)
        if match:
            marker = match.group(1)
            if fence_character is None:
                fence_character = marker[0]
                fence_length = len(marker)
            elif marker[0] == fence_character and len(marker) >= fence_length:
                fence_character = None
            continue
        if fence_character is None:
            lines.append(line)
    return lines, fence_character

def analyzeHeadings(lines):
    headings = re.findall(r"^(#{1,6})\s+(.+?)\s*#*\s*$", "\n".join(lines), re.MULTILINE)
    titles = [title for level, title in headings if len(level) == 1]
    reports = []
    if not titles:
        reports.append("Missing `#` title.")
    if len(titles) != len(set(titles)):
        reports.append("Duplicate `#` title.")
    if headings:
        levels = [len(level) for level, _ in headings]
        reports.append(f"Deepest header: `{ '#' * max(levels) }`.")
        for previous, current in zip(levels, levels[1:]):
            if current > previous + 1:
                reports.append(f"Heading level jump: `{ '#' * previous }` to `{ '#' * current }`.")
    return reports

def analyzeLocalLinks(markdown, markdown_path):
    reports = []
    for destination in re.findall(r"!?\[[^\]]*\]\(([^)]+)\)", markdown):
        destination = destination.strip().split(maxsplit=1)[0].strip("<>")
        if not destination or re.match(r"^[a-z][a-z0-9+.-]*:", destination, re.IGNORECASE):
            continue
        local_path = destination.split("#", 1)[0].split("?", 1)[0]
        if local_path and not (markdown_path.parent / local_path).exists():
            reports.append(f"Missing local link: `{destination}`.")
    return reports

visible_lines, unclosed_fence = removeCodeFences(text)
reports = analyzeHeadings(visible_lines)
if unclosed_fence is not None:
    reports.append("Unclosed code fence.")
reports.extend(analyzeLocalLinks(text, path))
print("\n".join(reports))
PY
    )"
    if [[ -n "$report" ]]; then
        WARNINGS+=("$file_path: $report")
        while IFS= read -r report_line; do
            printf 'WARN structure file=%s issue="%s"\n' "$file_path" "$report_line"
        done <<<"$report"
    fi
}

##--------------------------------------------------------------------------------------------------

lintFile() {
    local file_path="$1"
    checkMarkdownlint "$file_path"
    checkPrettier "$file_path"
    checkFrontmatter "$file_path"
    analyzeStructure "$file_path"
    formatDecorators "$file_path"
    printf 'PASS file=%s checks=markdownlint,prettier,frontmatter,structure,decorators\n' \
        "$file_path"
}

##==================================================================================================
##	MAIN
##==================================================================================================

main() {
    local file_path
    local skipped_tools
    if [[ $# -eq 2 && "$1" == --recursive ]]; then
        [[ -d "$2" ]] || die "Not a directory: $2"
        getMarkdownFiles "$2"
    elif [[ $# -eq 1 && "$1" != --* ]]; then
        [[ -f "$1" ]] || die "Not a file: $1"
        [[ "$1" == *.md ]] || die "Expected a .md file: $1"
        INPUT_FILES+=("$1")
    else
        printUsage >&2
        exit 2
    fi
    for file_path in "${INPUT_FILES[@]}"; do
        lintFile "$file_path"
    done
    if command -v git >/dev/null 2>&1; then
        runCheck git-diff-check git diff --check
    else
        recordSkippedTool git
        printf 'SKIP git diff --check: git unavailable\n'
    fi
    if ((${#SKIPPED_TOOLS[@]} > 0)); then
        skipped_tools="$(
            IFS=', '
            printf '%s' "${SKIPPED_TOOLS[*]}"
        )"
    else
        skipped_tools=none
    fi
    printf 'DONE files=%d structure_warnings=%d skipped=%s diff_check=pass\n' \
        "${#INPUT_FILES[@]}" "${#WARNINGS[@]}" "$skipped_tools"
}

##==================================================================================================

main "$@"
