#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

## TEMPLATE: Before ship: replace/remove TEMPLATE lines and examples. Run bash -n, shellcheck.

##==================================================================================================
##	DEPENDENCY CHECKS
##==================================================================================================

## TEMPLATE: Replace/remove examples. requireCommand for every non-baseline external binary.
requireCommand() { command -v "$1" >/dev/null 2>&1 || { printf 'error: command not found: %s\n' "$1" >&2; exit 1; }; }

requireCommand dependency_example # TEMPLATE: Replace/remove.

##==================================================================================================
##	GLOBALS
##==================================================================================================

## TEMPLATE: Replace/remove example globals.
declare -r SCRIPT_NAME="${0##*/}"

##==================================================================================================
##	UTILITIES
##==================================================================================================

die() { printf '%s: %s\n' "$SCRIPT_NAME" "$1" >&2; exit "${2:-1}"; }

## TEMPLATE: Add needed helpers from snippets.sh; else remove this section.

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

printUsage() { printf 'Usage: %s <required-arg>\n' "$SCRIPT_NAME"; }

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    printUsage
    exit 0
fi

[[ $# -eq 1 ]] || die "expected one argument — run with --help for usage"

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

main
