# nvim

Конфиг Neovim 0.12 в стиле native-first: сначала нативные возможности (LSP, completion,
диагностика, quickfix, folds), плагины закрывают только пробелы. Основной сценарий - ревью
кода и агентская разработка: Go, TypeScript, Python, Lua, SQL, markdown.

## Требования

- Neovim >= 0.12
- git, curl, unzip - для lazy.nvim и treesitter
- Node.js - для LSP-серверов (typescript, pyright, sql-форматтер)

## Установка

```sh
git clone https://github.com/s3nn1k/nvim.git ~/.config/nvim
make init        # Fedora; macOS: ./scripts/macos-bootstrap.sh
```

Bootstrap ставит системные зависимости и LSP-серверы (gopls, tsserver, pyright, luals,
bashls, ShellCheck). Плагины и парсеры устанавливаются автоматически при первом запуске;
версии зафиксированы в `lazy-lock.json`.

## Состав

| Слой           | Решение                                       |
| -------------- | --------------------------------------------- |
| Completion     | нативный `vim.lsp.completion`                 |
| Поиск          | telescope.nvim: файлы, grep, окна, буферы     |
| Файлы          | oil.nvim - редактирование каталога как буфера |
| Diff и ревью   | diffview.nvim                                 |
| Заметки        | obsidian.nvim (vaults)                        |
| Форматирование | conform.nvim                                  |
| UI             | lualine, noice; тема zenbox_dark (самописная) |

## Структура

| Путь               | Назначение                      |
| ------------------ | ------------------------------- |
| `init.lua`         | вход, загрузка core-модулей     |
| `lua/core/`        | options, mappings, lsp, plugins |
| `lua/plugins/`     | спеки lazy.nvim, файл на плагин |
| `lsp/`             | конфиги LSP-серверов            |
| `lua/zenbox_dark/` | тема: палитра + модули доменов  |
| `scripts/`         | bootstrap Fedora и macOS        |

## Разработка

```sh
make fmt       # stylua
make lint      # stylua --check
```
