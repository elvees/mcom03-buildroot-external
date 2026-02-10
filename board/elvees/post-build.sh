#!/bin/env bash
# Copyright 2026 RnD Center "ELVEES", JSC

set -euo pipefail

if [[ -f "${BINARIES_DIR}"/mcom03-fit-gen ]]; then
    rm -f "${TARGET_DIR}"/usr/bin/extlinux-gen
    rm -rf "${TARGET_DIR}"/boot/extlinux
    "${BINARIES_DIR}"/mcom03-fit-gen
fi
