#!/usr/bin/env bash

set -euo pipefail

readonly nvim_version="${NVIM_VERSION:-v0.11.5}"
readonly nvim_dir="/opt/nvim-linux-x86_64"
readonly repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(id -u)" -ne 0 ]; then
  echo "run this script as root" >&2
  exit 1
fi

if ! command -v apt-get >/dev/null; then
  echo "this script supports Ubuntu and Debian hosts" >&2
  exit 1
fi

if [ "$(uname -m)" != "x86_64" ]; then
  echo "this script supports x86_64 hosts" >&2
  exit 1
fi

apt-get update
apt-get install -y git stow unzip ripgrep

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/nvim.tar.gz"
curl -fsSL "https://github.com/neovim/neovim/releases/download/$nvim_version/nvim-linux-x86_64.tar.gz" -o "$archive"
tar -C /opt -xzf "$archive"
ln -sfn "$nvim_dir/bin/nvim" /usr/local/bin/nvim

stow -D -d "$repo_dir" -t "$HOME" git
stow -R -d "$repo_dir" -t "$HOME" nvim
