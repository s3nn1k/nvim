#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$(uname -s)" in
    Darwin) exec "$REPO_ROOT/platform/macos.sh" ;;
    Linux)  exec "$REPO_ROOT/platform/fedora.sh" ;;
    *)
        echo "Неподдерживаемая платформа: $(uname -s)" >&2
        exit 1
        ;;
esac
