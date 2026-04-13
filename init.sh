#!/bin/bash
set -e

log() { echo ""; echo "==> $*"; }

brew_ensure() {
    if brew list "$1" &>/dev/null; then
        brew upgrade "$1" 2>/dev/null && echo "  updated: $1" || echo "  up to date: $1"
    else
        brew install "$1" && echo "  installed: $1"
    fi
}

# ── Homebrew ────────────────────────────────────────────────────────────────

log "Homebrew..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update

# ── Neovim ──────────────────────────────────────────────────────────────────

log "Neovim..."
brew_ensure neovim

# ── Утилиты ─────────────────────────────────────────────────────────────────

log "Утилиты..."
for pkg in gcc make ripgrep git; do
    brew_ensure "$pkg"
done

# ── Языки ───────────────────────────────────────────────────────────────────

log "Языки..."
for pkg in go node python lua; do
    brew_ensure "$pkg"
done

# удалить node@24 если нет зависимостей — он ломает npm в PATH
if brew list node@24 &>/dev/null; then
    if [ -z "$(brew uses --installed node@24)" ]; then
        echo "  node: удаляю node@24 (нет зависимостей)..."
        brew uninstall node@24
    fi
fi

# ── LSP серверы ─────────────────────────────────────────────────────────────

log "LSP (brew)..."
brew_ensure lua-language-server

log "LSP (npm)..."
NPM="$(brew --prefix node)/bin/npm"
"$NPM" install -g \
    typescript-language-server \
    typescript \
    pyright \
    @mistweaverco/kulala-ls

log "LSP (go)..."
go install golang.org/x/tools/gopls@latest

# ── Форматтеры ──────────────────────────────────────────────────────────────

log "Форматтеры (brew)..."
for pkg in stylua taplo black; do
    brew_ensure "$pkg"
done

log "Форматтеры (npm)..."
"$NPM" install -g prettier sql-formatter

log "Форматтеры (go)..."
go install golang.org/x/tools/cmd/goimports@latest

# ────────────────────────────────────────────────────────────────────────────

log "Готово! Перезапусти Neovim — lazy.nvim установит плагины автоматически."
