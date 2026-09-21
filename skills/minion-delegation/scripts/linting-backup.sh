#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

##==================================================================================================
##	DEPENDENCY CHECKS
##==================================================================================================

requireCommand() {
    command -v "$1" >/dev/null || {
        printf 'Missing command: %s\n' "$1" >&2
        printUsage >&2
        exit 127
    }
}

##==================================================================================================
##	GLOBALS
##==================================================================================================

declare -r SCRIPT_NAME="${0##*/}"

##==================================================================================================
##	UTILITIES
##==================================================================================================

die() {
    printf '%s: %s\n' "$SCRIPT_NAME" "$1" >&2
    printUsage >&2
    exit 2
}

requireRegularFile() {
    local path="$1"
    local label="$2"

    [[ ! -L "$path" && -f "$path" ]] || die "$label must be a non-symlink regular file: $path"
}

requireNewBackupPath() {
    local path="$1"

    [[ ! -e "$path" && ! -L "$path" ]] || die "backup already exists or is a symlink: $path"
}

##==================================================================================================
##	CORE FUNCTIONS
##==================================================================================================

backupFile() {
    local source_path="$1"
    local backup_path="$2"

    requireRegularFile "$source_path" "source"
    requireNewBackupPath "$backup_path"
    if ! cp --preserve=mode,timestamps -- "$source_path" "$backup_path"; then
        die "could not create backup: $backup_path"
    fi
}

restoreFile() {
    local backup_path="$1"
    local target_path="$2"

    requireRegularFile "$backup_path" "backup"
    [[ ! -L "$target_path" && (! -e "$target_path" || -f "$target_path") ]] ||
        die "target must be absent or a regular file: $target_path"
    if ! cp --preserve=mode,timestamps -- "$backup_path" "$target_path"; then
        die "could not restore target: $target_path"
    fi
    cmp -s -- "$backup_path" "$target_path" || die "restore verification failed: $target_path"
}

compareFiles() {
    local before_path="$1"
    local after_path="$2"

    requireRegularFile "$before_path" "before"
    requireRegularFile "$after_path" "after"
    if diff -u --label "$after_path (before)" --label "$after_path (after)" -- "$before_path" "$after_path"; then
        return 0
    else
        local diff_status=$?

        [[ "$diff_status" -eq 1 ]] && return 1
        die "comparison failed: $after_path"
    fi
}

cleanupFile() {
    local backup_path="$1"

    requireRegularFile "$backup_path" "backup"
    if ! trash -- "$backup_path"; then
        die "could not clean up backup: $backup_path"
    fi
}

##==================================================================================================
##	ARGUMENT PARSING
##==================================================================================================

printUsage() {
    printf 'Usage:\n'
    printf '  %s backup SOURCE BACKUP\n' "$SCRIPT_NAME"
    printf '  %s restore BACKUP TARGET\n' "$SCRIPT_NAME"
    printf '  %s compare BEFORE AFTER\n' "$SCRIPT_NAME"
    printf '  %s cleanup BACKUP\n' "$SCRIPT_NAME"
    printf '\n'
    printf 'All paths must be regular files; symlinks are refused. compare exits 1 for differences.\n'
}

[[ $# -eq 1 && ("$1" == "-h" || "$1" == "--help") ]] && {
    printUsage
    exit 0
}
[[ ($# -eq 3 && "$1" != "cleanup") || ($# -eq 2 && "$1" == "cleanup") ]] ||
    die "expected a subcommand and its file paths"

declare -r SUBCOMMAND="$1"
declare -r FIRST_PATH="$2"
declare -r SECOND_PATH="${3:-}"

case "$SUBCOMMAND" in
backup) requireCommand cp ;;
restore)
    requireCommand cp
    requireCommand cmp
    ;;
compare) requireCommand diff ;;
cleanup) requireCommand trash ;;
esac

##==================================================================================================
##	MAIN
##==================================================================================================

main() {
    case "$SUBCOMMAND" in
    backup) backupFile "$FIRST_PATH" "$SECOND_PATH" ;;
    restore) restoreFile "$FIRST_PATH" "$SECOND_PATH" ;;
    compare) compareFiles "$FIRST_PATH" "$SECOND_PATH" ;;
    cleanup) cleanupFile "$FIRST_PATH" ;;
    *) die "unknown subcommand: $SUBCOMMAND" ;;
    esac
}

##==================================================================================================
##	SCRIPT ENTRY POINT
##==================================================================================================

if main; then
    exit 0
else
    declare -r EXIT_STATUS=$?

    [[ "$SUBCOMMAND" == "compare" && "$EXIT_STATUS" -eq 1 ]] && exit 1
    die "operation failed"
fi
