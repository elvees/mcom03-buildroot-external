#!/bin/env bash
# Copyright 2025 RnD Center "ELVEES", JSC

set -euo pipefail

SCRIPT=$(basename "$0")

help() {
    echo "$SCRIPT - The post build script to patch a target root filesystem"
    echo
    echo "Usage: $SCRIPT <TARGET DIR> [options]"
    echo
    echo "Options:"
    echo "  -a   colon-separated list of files or directories additionally to be"
    echo "       appended to target rootfs"
    echo "  -m   comma-separated systemd units to mask"
    echo
    echo "The script is depended on HOST_DIR environment variable"
    echo "pointed to a host sysroot dir. If HOST_DIR is not set,"
    echo "the root ('/') directory will be used as sysroot dir"
}

error() {
    echo "Error: $*" > /dev/stderr
    exit 1
}

do_rsync() {
    for UNIT in $2; do
        rsync -avR "$UNIT" "$1"/opt/
    done
}

do_systemctl() {
    for UNIT in $4; do
        "$1"bin/systemctl --root="$2" "$3" "$UNIT"
    done
}

set +u
[[ -z "$1" ]] && help && exit 0
[[ -e "$1" ]] || error "PATH to a target root filesystem has to be provided"
[[ "${HOST_DIR: -1}" == "/" ]] || HOST_DIR+=/
set -u

unset TARGET_DIR
TARGET_DIR=$1
shift 1

while getopts 'a:m:' opt; do
    case $opt in
        a) FILES_TO_BE_APPENDED="$OPTARG";;
        m) SYSTEMD_MASK_UNITS="$OPTARG";;
        *) ;;
    esac
done

if [[ -v FILES_TO_BE_APPENDED ]]; then
    do_rsync "${TARGET_DIR}" "${FILES_TO_BE_APPENDED//:/ }"
fi

if [[ -v SYSTEMD_MASK_UNITS ]]; then
    do_systemctl "${HOST_DIR}" "${TARGET_DIR}" mask "${SYSTEMD_MASK_UNITS//,/ }"
fi
