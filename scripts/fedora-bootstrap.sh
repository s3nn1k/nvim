#!/bin/bash
# Установщик зависимостей Neovim для Fedora: dnf, npm/pipx/go, lua-language-server из tarball.
set -euo pipefail

if [ "$(uname -s)" != "Linux" ]; then
    echo "Ожидался Linux, получено: $(uname -s)" >&2
    exit 1
fi
if ! grep -q '^ID=fedora$' /etc/os-release; then
    echo "Ожидался Fedora: нет ID=fedora в /etc/os-release" >&2
    exit 1
fi
if [ "$(id -u)" -eq 0 ]; then
    echo "Под root запускать не нужно: dnf через sudo, файлы ставятся в \$HOME" >&2
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"
export GOBIN="$HOME/.local/bin"
export npm_config_nodedir=/usr

log() { echo ""; echo "==> $*"; }

# ── Пакеты dnf ──────────────────────────────────────────────────────────────

log "dnf..."
sudo dnf install -y neovim gcc gcc-c++ make ripgrep git tree-sitter-cli golang nodejs nodejs-devel npm python3 pipx

[ -f /usr/include/node/node_api.h ] || { echo "нет заголовков node - нужен nodejs-devel" >&2; exit 1; }
# ── LSP и форматтеры (npm) ──────────────────────────────────────────────────

log "npm..."
npm install --global --prefix "$HOME/.local" \
    typescript@7.0.2 \
    pyright \
    @mistweaverco/kulala-ls \
    prettier \
    sql-formatter \
    @johnnymorganz/stylua-bin@2.6.0 \
    @taplo/cli@0.7.0

# ── Форматтер (pipx) ────────────────────────────────────────────────────────

log "pipx..."
pipx install --force black

# ── LSP и форматтеры (go) ───────────────────────────────────────────────────

log "go..."
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

# ── lua-language-server (tarball) ───────────────────────────────────────────

log "lua-language-server..."
lls_version="3.19.2"
lls_tarball="lua-language-server-${lls_version}-linux-x64.tar.gz"
lls_url="https://github.com/LuaLS/lua-language-server/releases/download/${lls_version}/${lls_tarball}"
lls_sha256="93ad326b10f6c00911dd8c450fa098332dbd8f9f45d1052f5636a2d54479b947"
lls_cache="$HOME/.cache/nvim-bootstrap"
mkdir -p "$lls_cache"
if ! echo "${lls_sha256}  ${lls_tarball}" | (cd "$lls_cache" && sha256sum --check --status); then
    curl -fL "$lls_url" -o "$lls_cache/${lls_tarball}.part"
    echo "${lls_sha256}  ${lls_tarball}.part" | (cd "$lls_cache" && sha256sum --check -)
    mv "$lls_cache/${lls_tarball}.part" "$lls_cache/${lls_tarball}"
fi
mkdir -p "$HOME/.local/share/lua-language-server"
tar -xzf "$lls_cache/${lls_tarball}" -C "$HOME/.local/share/lua-language-server"
ln -sfnT "$HOME/.local/share/lua-language-server/bin/lua-language-server" "$HOME/.local/bin/lua-language-server"

# ── Плагины ─────────────────────────────────────────────────────────────────

log "lazy.nvim..."
nvim --headless '+Lazy! restore' +qa
