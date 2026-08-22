#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

##==================================================================================================
##	GLOBALS
##==================================================================================================

readonly FILE_TIDY_SHOW_LIMIT=20

##==================================================================================================
##	UTILITIES
##==================================================================================================

die() {
  printf '%s\n' "$*" >&2
  exit 2
}

require_commands() {
  local command
  for command in "$@"; do
    command -v "$command" >/dev/null || die "Missing command: $command"
  done
}

scope_root() {
  local requested=${1:-.} root target
  [[ -n ${PWD:-} ]] || die "Current directory unavailable"
  root=$(realpath -e -- "$PWD") || die "Cannot resolve current directory"
  [[ $root != / ]] || die "Refusing unbounded current directory"
  target=$(realpath -e -- "$requested") || die "Cannot resolve directory: $requested"
  [[ -d $target ]] || die "Not a directory: $target"
  case $target in
    "$root"|"$root"/*) printf '%s' "$target" ;;
    *) die "Refusing path outside current directory" ;;
  esac
}

show_path() {
  local count=$1 label=$2 path=$3
  (( count < FILE_TIDY_SHOW_LIMIT )) || return 0
  printf '%s\t%q\n' "$label" "$path"
}

bytes_human() {
  local bytes=$1 unit=0
  local -a units=(B KiB MiB GiB TiB)
  while (( bytes >= 1024 && unit < ${#units[@]} - 1 )); do
    bytes=$((bytes / 1024))
    ((unit += 1))
  done
  printf '%d %s' "$bytes" "${units[$unit]}"
}
