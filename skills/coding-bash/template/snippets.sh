## Copy only required blocks into `script.sh`. Not a standalone script.

## getScriptName PATH — basename of a script or resource path
getScriptName() { basename -- "$1"; }

## getScriptDirectory — absolute physical directory containing this script
getScriptDirectory() ( cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P; )

## isCommandAvailable COMMAND — return 0 if COMMAND is on PATH
isCommandAvailable() { command -v "$1" >/dev/null 2>&1; }

## isRootUser — return 0 when effective user is root
isRootUser() { [[ "${EUID}" -eq 0 ]]; }

## getTimestamp — ISO-8601 timestamp for log lines or filenames
getTimestamp() { date '+%Y-%m-%dT%H:%M:%S'; }

## getDate — ISO-8601 date for log lines or filenames
getDate() { date '+%Y-%m-%d'; }

## createTemporaryDirectory — creates a unique workspace; caller owns cleanup
createTemporaryDirectory() { mktemp -d "${TMPDIR:-/tmp}/script.XXXXXX"; }

## cleanupTemporaryDirectory PATH — move a temporary workspace to trash
cleanupTemporaryDirectory() { trash "$1" >/dev/null 2>&1 || true; }

## confirmExactText PROMPT EXPECTED — return 0 only for exact confirmation
confirmExactText() {
    local prompt="$1"
    local expected="$2"
    local answer

    IFS= read -r -p "$prompt" answer
    [[ "$answer" == "$expected" ]]
}

## Process find output safely: while IFS= read -r -d '' path; do ...; done
##     < <(find "$directory" -type f -print0)

## logMessage LEVEL MESSAGE... — colored stderr output
logMessage() {
    local level="$1"
    local color=""
    shift

    case "$level" in
        INFO) color='\033[1m' ;;
        WARN) color='\033[1;33m' ;;
        ERROR) color='\033[0;31m' ;;
        DONE) color='\033[0;32m' ;;
        *) die "unknown log level: $level" ;;
    esac

    printf '%b[%s]\033[0m %s\n' "$color" "$level" "$*" >&2
}

## logVerbose MESSAGE... — emit INFO line only when VERBOSE=true
logVerbose() {
    if [[ "${VERBOSE:-false}" == true ]]; then
        logMessage INFO "$@"
    fi
}
