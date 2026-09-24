#!/bin/bash
set -e

log() { echo ""; echo "==> $*"; }

brew_ensure() {
    local cask_opts=()
    [[ "$2" == "cask" ]] && cask_opts=(--cask)
    if brew list "${cask_opts[@]}" "$1" &>/dev/null; then
        brew upgrade "${cask_opts[@]}" "$1" 2>/dev/null && echo "  updated: $1" || echo "  up to date: $1"
    else
        brew install "${cask_opts[@]}" "$1" && echo "  installed: $1"
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
for pkg in gcc make ripgrep git tree-sitter-cli; do
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
# typescript: с 7.x LSP встроен в сам пакет (tsc --lsp --stdio), обёртка не нужна
NPM="$(brew --prefix node)/bin/npm"
"$NPM" install -g \
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

# ── Шрифты ──────────────────────────────────────────────────────────────────

log "Шрифты..."
brew_ensure font-hack-nerd-font cask

# ── iTerm2 ──────────────────────────────────────────────────────────────────

# шрифт профиля по умолчанию; размер текущего шрифта сохраняется
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
if [[ -f "$ITERM_PLIST" ]]; then
    SIZE=$(/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Normal Font'" "$ITERM_PLIST" 2>/dev/null | awk '{print $NF}')
    SIZE="${SIZE:-12}"
    if /usr/libexec/PlistBuddy -c "Set :'New Bookmarks':0:'Normal Font' 'HackNerdFont-Regular ${SIZE}'" "$ITERM_PLIST" 2>/dev/null; then
        echo "  шрифт профиля: Hack Nerd Font (${SIZE}); перезапусти iTerm2 полностью (Cmd+Q)"
    else
        echo "  профиль по умолчанию не найден - пропускаю"
    fi
else
    echo "  iTerm2 не найден - пропускаю"
fi

# ────────────────────────────────────────────────────────────────────────────

log "Готово! Перезапусти Neovim — lazy.nvim установит плагины автоматически."
