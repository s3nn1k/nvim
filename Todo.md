# TODO

## Восстановить injection-запросы после фикса nvim-treesitter для Neovim 0.12

Проблема: nvim-treesitter передаёт nil в `vim.treesitter.get_node_text()`, которая в Neovim 0.12
перестала защищаться от этого. Временно отключены все injection-запросы.

Что сломано:
- Подсветка SQL внутри Go-строк
- Подсветка кода внутри Markdown-блоков (hover и др.)
- TypeScript injections

Когда выйдет фикс:

1. Обновить nvim-treesitter: `:Lazy update nvim-treesitter`
2. Проверить что ошибка ушла (открыть Go/TS файл, нажать `<leader>k`)
3. Восстановить файлы:

```bash
cp queries/go/injections.scm.bak queries/go/injections.scm
rm queries/go/injections.scm.bak
rm queries/typescript/injections.scm
rm queries/markdown/injections.scm
rm queries/markdown_inline/injections.scm
```
