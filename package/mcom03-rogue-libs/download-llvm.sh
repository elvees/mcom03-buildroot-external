#!/usr/bin/env bash
# Copyright 2020 RnD Center "ELVEES", JSC

SCRIPT=$(basename $0)
LLVM_BUILD_DIR="$1"
LLVM_VERSION=3.7.0

declare -A TARBALL_LIST
TARBALL_LIST=(
        [llvm]="CHECKSUM=b98b9495e5655a672d6cb83e1a180f8e
                VERSION=${LLVM_VERSION}
                URL=http://llvm.org/releases/${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz
                FILENAME=llvm-${LLVM_VERSION}.src.tar.xz"

        [cfe]="CHECKSUM=8f9d27335e7331cf0a4711e952f21f01
                VERSION=${LLVM_VERSION}
                URL=http://llvm.org/releases/${LLVM_VERSION}/cfe-${LLVM_VERSION}.src.tar.xz
                FILENAME=cfe-${LLVM_VERSION}.src.tar.xz"
        )

echo "LLVM_BUILD_DIR=${LLVM_BUILD_DIR}"

# If the directory doesn't exist, create it
mkdir -p ${LLVM_BUILD_DIR}
cd ${LLVM_BUILD_DIR}
# Ensure LLVM_BUILD_DIR is absolute
LLVM_BUILD_DIR=$(pwd)

# Check tarballs list and download if necessary.
#
# Arguments: None
# Globals used:
#   TARBALL_LIST : Associative array of tarballs to prepare
#   SCRIPT : Name of the called script
# Globals set as output: None
prepare_tarballs () {
# Variables used by list
    local CHECKSUM
    local URL
    local FILENAME

    for i in "${!TARBALL_LIST[@]}"; do
        eval ${TARBALL_LIST[$i]}

        if [ -f "${FILENAME}" ]; then
        if [ $(md5sum "${FILENAME}" | cut -d' ' -f1) != "${CHECKSUM}" ]; then
            echo "Tarball checksum failed. Removing old archive ..."
            rm "${FILENAME}"
        fi
        fi

        if [ ! -f "${FILENAME}" ]; then
        wget "${URL}" -O "${FILENAME}"
        fi

        if [ $(md5sum "${FILENAME}" | cut -d' ' -f1) != "${CHECKSUM}" ]; then
        echo "Tarball checksum failed, checksum and/or url in ${SCRIPT} is wrong!"
        exit 1
        fi
    done
}

prepare_tarballs
