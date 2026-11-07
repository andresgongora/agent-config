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
declare -a CHECKS_RUN=()
FIX_MODE=false # true only with --fix; default is check-only
DIFF_CHECK_STATUS=not-run

##==================================================================================================
##	UTILITIES
##==================================================================================================

die() {
    printf '%s: %s\n' "$SCRIPT_NAME" "$1" >&2
    exit 1
}

printUsage() {
    printf 'Usage: %s [--fix] <file.md>\n       %s [--fix] --recursive <directory>\n' \
        "$SCRIPT_NAME" "$SCRIPT_NAME"
}

recordCheck() {
    CHECKS_RUN+=("$1")
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

## Arguments: file_path, mode (check|fix). Check mode exits 1 when spacing differs.
formatDecorators() {
    local file_path="$1"
    local mode="$2"
    python3 - "$file_path" "$mode" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text()
lines = text.splitlines(keepends=True)
decorator = re.compile(r"^<!-{10,}>\s*(?:\r?\n)?$")
heading = re.compile(r"^#{1,6}\s+\S")
index = 0
while index < len(lines):
    if not decorator.match(lines[index]):
        index += 1
        continue

    header_index = index + 1
    while header_index < len(lines) and lines[header_index].strip() == "":
        header_index += 1
    if header_index == len(lines) or not heading.match(lines[header_index]):
        index += 1
        continue

    closing_index = header_index + 1
    while closing_index < len(lines) and lines[closing_index].strip() == "":
        closing_index += 1
    if closing_index == len(lines) or not decorator.match(lines[closing_index]):
        index += 1
        continue

    del lines[index + 1:header_index]
    closing_index = index + 2
    while closing_index < len(lines) and lines[closing_index].strip() == "":
        del lines[closing_index]

    if index > 0 and lines[index - 1].strip() != "":
        lines.insert(index, "\n")
        index += 1
        closing_index += 1
    if closing_index + 1 < len(lines) and lines[closing_index + 1].strip() != "":
        lines.insert(closing_index + 1, "\n")
    index = closing_index + 2
formatted = "".join(lines)
if sys.argv[2] == "fix":
    path.write_text(formatted)
elif formatted != text:
    sys.exit(1)
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
    local -a markdownlint_arguments=()
    if [[ "$FIX_MODE" == true ]]; then
        markdownlint_arguments+=(--fix)
    fi
    if [[ -n "$markdownlint_config" ]]; then
        markdownlint_arguments+=(--config "$markdownlint_config")
    fi
    runCheck markdownlint-cli2 markdownlint-cli2 "${markdownlint_arguments[@]}" -- "$file_path"
    recordCheck markdownlint
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
    recordCheck prettier
}

##--------------------------------------------------------------------------------------------------

## Managed paths require frontmatter; other files skip the check unless they open with `---`.
isFrontmatterManaged() {
    local file_path="$1"
    case "$file_path" in
        README.md | */README.md) return 1 ;;
        .agent/* | */.agent/* | SKILL.md | */SKILL.md | agents/* | */agents/* | commands/* | */commands/*)
            return 0
            ;;
    esac
    return 1
}

checkFrontmatter() {
    local file_path="$1"
    local first_line
    IFS= read -r first_line <"$file_path" || true
    if [[ "$first_line" != --- ]]; then
        isFrontmatterManaged "$file_path" || return 0
        printf 'FAIL check=frontmatter file=%s\nmissing frontmatter\n' "$file_path" >&2
        return 1
    fi
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
    recordCheck frontmatter
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
        destination_parts = destination.strip().split(maxsplit=1)
        if not destination_parts:
            continue
        destination = destination_parts[0].strip("<>")
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
reports.extend(analyzeLocalLinks("\n".join(visible_lines), path))
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
    local warnings_before="${#WARNINGS[@]}"
    local checks_joined
    CHECKS_RUN=()
    checkMarkdownlint "$file_path"
    checkPrettier "$file_path"
    checkFrontmatter "$file_path"
    analyzeStructure "$file_path"
    recordCheck structure
    if [[ "$FIX_MODE" == true ]]; then
        formatDecorators "$file_path" fix
    elif ! formatDecorators "$file_path" check; then
        WARNINGS+=("$file_path: decorator spacing differs from canonical form")
        printf 'WARN decorators file=%s issue="spacing differs; rerun with --fix"\n' "$file_path"
    fi
    recordCheck decorators
    checks_joined="$(
        IFS=,
        printf '%s' "${CHECKS_RUN[*]}"
    )"
    if ((${#WARNINGS[@]} > warnings_before)); then
        printf 'WARN file=%s checks=%s\n' "$file_path" "$checks_joined"
    else
        printf 'PASS file=%s checks=%s\n' "$file_path" "$checks_joined"
    fi
}

lintGit() {
    local inside_work_tree
    if ! command -v git >/dev/null 2>&1; then
        recordSkippedTool git
        DIFF_CHECK_STATUS=unavailable
        printf 'SKIP git diff --check: git unavailable\n'
        return
    fi
    if ! inside_work_tree="$(git rev-parse --is-inside-work-tree 2>&1)" ||
        [[ "$inside_work_tree" != true ]]; then
        DIFF_CHECK_STATUS=not-worktree
        return
    fi
    runCheck git-diff-check git diff --check
    DIFF_CHECK_STATUS=pass
}

##==================================================================================================
##	MAIN
##==================================================================================================

main() {
    local file_path
    local skipped_tools
    local recursive_directory=""
    local -a file_arguments=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --fix) FIX_MODE=true ;;
            --recursive)
                [[ $# -ge 2 ]] || {
                    printUsage >&2
                    exit 2
                }
                recursive_directory="$2"
                shift
                ;;
            --*)
                printUsage >&2
                exit 2
                ;;
            *) file_arguments+=("$1") ;;
        esac
        shift
    done
    if [[ -n "$recursive_directory" ]]; then
        if ((${#file_arguments[@]} > 0)); then
            printUsage >&2
            exit 2
        fi
        [[ -d "$recursive_directory" ]] || die "Not a directory: $recursive_directory"
        getMarkdownFiles "$recursive_directory"
    else
        if ((${#file_arguments[@]} != 1)); then
            printUsage >&2
            exit 2
        fi
        [[ -f "${file_arguments[0]}" ]] || die "Not a file: ${file_arguments[0]}"
        [[ "${file_arguments[0]}" == *.md ]] || die "Expected a .md file: ${file_arguments[0]}"
        INPUT_FILES+=("${file_arguments[0]}")
    fi
    for file_path in "${INPUT_FILES[@]}"; do
        lintFile "$file_path"
    done
    lintGit
    if ((${#SKIPPED_TOOLS[@]} > 0)); then
        skipped_tools="$(
            IFS=', '
            printf '%s' "${SKIPPED_TOOLS[*]}"
        )"
    else
        skipped_tools=none
    fi
    printf 'DONE files=%d warnings=%d skipped=%s diff_check=%s\n' \
        "${#INPUT_FILES[@]}" "${#WARNINGS[@]}" "$skipped_tools" "$DIFF_CHECK_STATUS"
}

##==================================================================================================

main "$@"
