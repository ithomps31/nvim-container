#!/bin/env bash

# ENV Vars
REPO_NAME="quay.io/plebs_inc/nvim"
IMAGE_NAME="minimal"
EX_FILE="./examples/example.json"

NVIM_TAR_URL="https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz"
NVIM_TAR="nvim-linux-x86_64.tar.gz"

# Scratch setup
nvim_container=$(buildah from scratch)
scratchmnt=$(buildah mount $nvim_container)

# Remove artifacts at exit
cleanup() {
    buildah umount "$nvim_container" >/dev/null 2>&1 || true
}
trap cleanup EXIT

# Install jq
dnf -y --installroot $scratchmnt \
    --disablerepo=* \
    --enablerepo=rhel-9-for-x86_64-baseos-rpms \
    --releasever 9 \
    --setopt install_weak_deps=false \
    --setopt=tsflags=nodocs \
    install python3 python3-pip tar lua gettext curl git

# Cache removal
dnf --installroot $scratchmnt clean all && rm -rf /var/cache/dnf
rm -rf "$scratchmnt"/var/cache/dnf \
       "$scratchmnt"/var/log/dnf* \
       "$scratchmnt"/var/log/hawkey*


# Add example file and set entrypoint
buildah copy $nvim_container ./${EX_FILE} /app/${EX_FILE}
buildah config --entrypoint '/usr/bin/bash' $nvim_container

# Save jq image
buildah commit $nvim_container ${REPO_NAME}:${IMAGE_NAME}
