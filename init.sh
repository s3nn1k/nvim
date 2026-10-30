#!/bin/bash
# Установщик зависимостей Neovim: диспетчер по платформе, логика в scripts/*-bootstrap.sh.
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
    Darwin) exec "$DIR/scripts/macos-bootstrap.sh" ;;
    Linux)  exec "$DIR/scripts/fedora-bootstrap.sh" ;;
    *)
        echo "Неподдерживаемая платформа: $(uname -s)" >&2
        exit 1
        ;;
esac
