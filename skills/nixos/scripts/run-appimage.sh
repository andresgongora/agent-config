#!/usr/bin/env bash
# Extract and run an AppImage under an FHS sandbox, without needing FUSE.
# Usage: run-appimage.sh <path-to-appimage> [nixpkgs#lib-attr ...]
#
# Extra args are nixpkgs attributes (e.g. nixpkgs#xcb-util-cursor) whose
# lib output gets appended to LD_LIBRARY_PATH inside the FHS sandbox, for
# libraries missing from the baseline FHS environment.
set -Eeuo pipefail
IFS=$'\n\t'

requireCommand() { command -v "$1" >/dev/null 2>&1 || { printf "Abort: '%s' not found\n" "$1" >&2; exit 1; }; }
requireCommand fhs
requireCommand nix

die() { printf '%s\n' "$1" >&2; exit "${2:-1}"; }

[[ $# -ge 1 ]] || die "Usage: $0 <path-to-appimage> [nixpkgs#lib-attr ...]"

APPIMAGE_PATH="$(realpath -- "$1")"
shift
EXTRA_PKGS=("$@")

[[ -f "$APPIMAGE_PATH" ]] || die "appimage not found: $APPIMAGE_PATH"

EXTRACT_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/appimage-extracted/$(basename -- "$APPIMAGE_PATH")"

extract() {
    [[ -x "${EXTRACT_DIR}/AppRun" ]] && return 0

    chmod +x "$APPIMAGE_PATH"

    local work_dir
    work_dir="$(mktemp -d)"
    (cd "$work_dir" && fhs -c "'${APPIMAGE_PATH}' --appimage-extract" >/dev/null)
    mkdir -p "$(dirname -- "$EXTRACT_DIR")"
    mv "${work_dir}/squashfs-root" "$EXTRACT_DIR"
}

launch() {
    local lib_path="${EXTRACT_DIR}/usr/lib"

    local pkg
    for pkg in "${EXTRA_PKGS[@]}"; do
        local out
        out="$(nix eval --raw "${pkg}.outPath")"
        lib_path="${lib_path}:${out}/lib"
    done

    fhs -c "LD_LIBRARY_PATH='${lib_path}' '${EXTRACT_DIR}/AppRun'"
}

extract
launch
