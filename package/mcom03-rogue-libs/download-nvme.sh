#!/usr/bin/env bash
# Copyright 2020 RnD Center "ELVEES", JSC

SCRIPT=$(basename $0)
NVME_BUILD_DIR="$1"

NNVM_VERSION=770f6ff3ebea4e60775ce24ff41c8f95e7ed12f6
NNVM_DMLC_VERSION=42823a731bdb2c22aa44775c0937466046400c02
TVM_VERSION=6287a99b9c65ae3a2453047a69d5db73838bd932
HALIDEIR_VERSION=e20e5e9abb3aa43147a90a4ffb3e190f62862970
DLPACK_VERSION=10892ac964f1af7c81aae145cd3fab78bbccd297
TVM_DMLC_VERSION=d3f7fbb53e5b037c0f5bf6bd21871ccc720690cc

declare -A TARBALL_LIST
TARBALL_LIST=(
        [nnvm]="CHECKSUM=41f03198a35e609a1433a9dc9e940e92
        VERSION=${NNVM_VERSION}
        URL=https://github.com/dmlc/nnvm/archive/${NNVM_VERSION}.zip
        FILENAME=nnvm-${NNVM_VERSION}.zip"
        [nnvm_dmlc]="CHECKSUM=290efc7064b0c147c8aea2cfb453cc63
        VERSION=${NNVM_DMLC_VERSION}
        URL=https://github.com/dmlc/dmlc-core/archive/${NNVM_DMLC_VERSION}.zip
        FILENAME=nnvm_dmlc-${NNVM_DMLC_VERSION}.zip"
        [tvm]="CHECKSUM=e3f38437c9af18ea326abecf067b7bc9
        VERSION=${TVM_VERSION}
        URL=https://github.com/dmlc/tvm/archive/${TVM_VERSION}.zip
        FILENAME=tvm-${TVM_VERSION}.zip"
        [halideir]="CHECKSUM=8c15efc7d5571838effdab3f89a08c05
        VERSION=${HALIDEIR_VERSION}
        URL=https://github.com/dmlc/HalideIR/archive/${HALIDEIR_VERSION}.zip
        FILENAME=halideir-${HALIDEIR_VERSION}.zip"
        [dlpack]="CHECKSUM=1c723a379512bb1869419cc091b7cd91
        VERSION=${DLPACK_VERSION}
        URL=https://github.com/dmlc/dlpack/archive/${DLPACK_VERSION}.zip
        FILENAME=dlpack-${DLPACK_VERSION}.zip"
        [tvm_dmlc]="CHECKSUM=6024f575718e0f6f6ef0d796f0c7c59f
        VERSION=${TVM_DMLC_VERSION}
        URL=https://github.com/dmlc/dmlc-core/archive/${TVM_DMLC_VERSION}.zip
        FILENAME=tvm_dmlc-${TVM_DMLC_VERSION}.zip"
        )

echo "NVME_BUILD_DIR=${NVME_BUILD_DIR}"

# If the directory doesn't exist, create it
mkdir -p ${NVME_BUILD_DIR}
cd ${NVME_BUILD_DIR}
# Ensure NVME_BUILD_DIR is absolute
NVME_BUILD_DIR=$(pwd)

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
    local VERSION
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
