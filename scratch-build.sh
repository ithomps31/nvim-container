#!/usr/bin/env bash
set -euo pipefail

# ENV Vars
REPO_NAME="quay.io/plebs_inc/nvim"
IMAGE_NAME="minimal"
EX_FILE="./examples/example.json"
PY_EX_FILE="./examples/example.py"
CONF_FILE="./init.lua"

NVIM_TAR_URL="https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz"
NVIM_TAR="/tmp/nvim-linux-x86_64.tar.gz"

# Scratch setup
nvim_container=$(buildah from scratch)
scratchmnt=$(buildah mount "$nvim_container")

# Cleanup on exit
cleanup() {
    buildah umount "$nvim_container" >/dev/null 2>&1 || true
    rm -f "$NVIM_TAR"
}
trap cleanup EXIT

# 1. Install base dependencies into target rootfs (lean RHEL 9 packages)
dnf -y --installroot "$scratchmnt" \
    --disablerepo=* \
    --enablerepo=rhel-9-for-x86_64-baseos-rpms \
    --enablerepo=rhel-9-for-x86_64-appstream-rpms \
    --releasever 9 \
    --setopt=install_weak_deps=False \
    --setopt=tsflags=nodocs \
    install \
        bash \
        coreutils-single \
        glibc-minimal-langpack \
        ncurses-base \
        ca-certificates \
        curl \
        tar \
        gzip \
        git \
        python3 \
        python3-pip \
        shadow-utils

# 2. Fetch and unpack Neovim binary directly into /usr/local
curl -fsSL "$NVIM_TAR_URL" -o "$NVIM_TAR"
tar -xzf "$NVIM_TAR" -C "$scratchmnt/usr/local" --strip-components=1

# 3. Clean package manager metadata from target filesystem
dnf --installroot "$scratchmnt" clean all
rm -rf "$scratchmnt"/var/cache/dnf \
       "$scratchmnt"/var/cache/yum \
       "$scratchmnt"/var/log/dnf* \
       "$scratchmnt"/var/log/hawkey* \
       "$scratchmnt"/tmp/*

# 4. Set up non-root user (nvimuser, UID/GID 1000) directly in rootfs
echo "nvimuser:x:1000:1000::/home/nvimuser:/bin/bash" >> "${scratchmnt}/etc/passwd"
echo "nvimuser:x:1000:" >> "${scratchmnt}/etc/group"
echo "nvimuser:x:1000:1000:::/sbin/nologin" >> "${scratchmnt}/etc/shadow" 2>/dev/null || true

mkdir -p "${scratchmnt}/home/nvimuser/.config/nvim"
chown -R 1000:1000 "${scratchmnt}/home/nvimuser"

# 5. Copy configuration / assets
if [[ -f "${EX_FILE}" ]]; then
    mkdir -p "$scratchmnt/app/examples"
    buildah copy "$nvim_container" "${EX_FILE}" "/app/examples/example.json"
fi
if [[ -f "${PY_EX_FILE}" ]]; then
    mkdir -p "$scratchmnt/app/examples"
    buildah copy "$nvim_container" "${PY_EX_FILE}" "/app/examples/example.py"
    chown 1000:1000 "${scratchmnt}/app/examples/example.py"
fi

if [[ -f "${CONF_FILE}" ]]; then
    buildah copy "$nvim_container" "${CONF_FILE}" "/home/nvimuser/.config/nvim/init.lua"
    chown 1000:1000 "${scratchmnt}/home/nvimuser/.config/nvim/init.lua"
fi

# 6. Install python-lsp-server globally inside the container environment via pip
buildah run --user 0:0 "$nvim_container" pip3 install --no-cache-dir python-lsp-server

# 7. Pre-bake plugins during build via headless Neovim
echo "Pre-installing plugins..."
buildah run --user 1000:1000 "$nvim_container" nvim --headless "+q"

# 8. Configure container runtime environment & user settings
buildah config --user 1000:1000 "$nvim_container"
buildah config --workingdir "/home/nvimuser" "$nvim_container"
buildah config --env TERM="xterm-256color" "$nvim_container"
buildah config --env LANG="C.UTF-8" "$nvim_container"
buildah config --cmd '["/bin/bash"]' "$nvim_container"

# 9. Commit container image
buildah commit "$nvim_container" "${REPO_NAME}:${IMAGE_NAME}"
