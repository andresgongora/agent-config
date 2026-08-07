#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

## TEMPLATE: Before ship: replace/remove TEMPLATE lines and examples. Run bash -n, shellcheck.

##==================================================================================================
##	DEPENDENCY CHECKS
##==================================================================================================

## TEMPLATE: Keep this section only for runtime external dependencies; else remove it.

requireCommand() { command -v "$1" >/dev/null 2>&1 || { printf "Abort: '%s' not found\n" "$1" >&2; exit 1; }; }

requireCommand dependency_example # TEMPLATE: Replace/remove.

##==================================================================================================
##	GLOBALS
##==================================================================================================

## TEMPLATE: Replace/remove example globals.

declare -r SCRIPT_NAME="${0##*/}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
declare -r SCRIPT_DIR

##==================================================================================================
##	UTILITIES
##==================================================================================================

## TEMPLATE: Add needed helpers from snippets.sh; else remove this section.
## TEMPLATE: Or add small helper functions here, e.g. for handling i/o or formatting.
## TEMPLATE: Keep helpers small and focused; core logic goes in core functions below.

die() { printf '%s: %s\n' "$SCRIPT_NAME" "$1" >&2; exit "${2:-1}"; } # Exit with message.

##==================================================================================================
##	CORE FUNCTIONS
##==================================================================================================

## TEMPLATE: One function per logical operation. Split when a function grows past easy reading.
## Core functions receive data via parameters — never read arg globals directly.

##--------------------------------------------------------------------------------------------------
## Example
##--------------------------------------------------------------------------------------------------

## @brief Example function. Replace or remove.
printHello() {
    local name="$1"
    printf 'Hello, %s!\n' "$name"
}

##==================================================================================================
##	ARGUMENT PARSING
##==================================================================================================

printUsage() {
    printf 'Usage:\n'
    printf '  %s <required-arg>      Run script with required argument\n' "$SCRIPT_NAME"
    printf '\n'
    printf 'Options:\n'
    printf '  -h, --help             Show this message\n'
    printf '\n'
    printf 'Examples:\n'
    printf '  %s Alice\n' "$SCRIPT_NAME"
    printf '  %s "Some Value"\n' "$SCRIPT_NAME"
    printf '\n'
    printf 'Shell alias (optional) — add to ~/.bashrc:\n'
    printf '  alias myscript='"'"'%s/%s'"'"'\n' "$SCRIPT_DIR" "$SCRIPT_NAME"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    printUsage
    exit 0
fi

## TEMPLATE: Set clear expectations for arguments. Replace/remove examples below.
## TEMPALTE: Reject if not argument expected `[[ $# -eq 0 ]] || die "no arguments expected"`
[[ $# -eq 1 ]] || die "expected one argument; run with --help for usage"

declare -r INPUT_ARGUMENT="$1"

##==================================================================================================
##	MAIN
##==================================================================================================

main() {
    ## TEMPLATE: Replace with core-function calls. main owns arg globals; keep it short.
    printHello "$INPUT_ARGUMENT"
}

##==================================================================================================
##	SCRIPT ENTRY POINT
##==================================================================================================

## TEMPLATE: Unless argument list is trivial, do not pass arguments into main; use globals instead.
main
