#!/bin/sh

_running_kernel() {
    uname -r
}

_installed_kernel() {
    local KERNEL_VERSION="$(file "/boot/vmlinuz-linux")"

    KERNEL_VERSION="${KERNEL_VERSION#*version }"
    KERNEL_VERSION="${KERNEL_VERSION%% (*}"

    echo "${KERNEL_VERSION}"
}

RUNNING_KERNEL="$(_running_kernel)"
INSTALLED_KERNEL="$(_installed_kernel)"

if [ "${RUNNING_KERNEL}" == "${INSTALLED_KERNEL}" ] ; then
    false
else
    echo "Kernel update ${RUNNING_KERNEL} -> ${INSTALLED_KERNEL}"
    true
fi
