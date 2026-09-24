# Neovim config

Персональный конфиг Neovim, только macOS.

# Установка

Клонировать репозиторий в `~/.config/nvim`, запустить `./init.sh`. После - открыть Neovim,
плагины установятся автоматически.

Обновление зависимостей и плагинов - тот же `./init.sh`, затем `:Lazy update` внутри
Neovim.

# Зависимости

Всё, кроме шрифта, ставится через `./init.sh`.

- Утилиты (brew): gcc, make, ripgrep, git, tree-sitter-cli, neovim
- Языки (brew): go, node, python, lua
- LSP:
  - brew: lua-language-server
  - npm: typescript, pyright, @mistweaverco/kulala-ls
  - go install: gopls
- Форматтеры:
  - brew: stylua, taplo, black
  - npm: prettier, sql-formatter
  - go install: goimports
- Hack Nerd Font - обязателен (иконки web-devicons, диагностические знаки); ставится из
  ~/dotfiles (Brewfile), там же шрифт профиля iTerm2 (DynamicProfiles)

# Правила добавления плагинов

1. Один плагин - один явный конфиг-файл `lua/plugins/<имя>.lua` (LSP-сервер -
   `lsp/<имя>.lua`, тема - `lua/themes/`); нигде не регистрируем плагины списком.
2. Хоткеи: включаем только явно используемые; дефолтные неиспользуемые хоткеи плагина
   отключаем явно (`false` / `"none"` в маппингах плагина).
3. Не добавляем плагины без поддержки: последний коммит автора старше 3 месяцев - не
   берём.
4. Каждая внешняя зависимость (CLI, LSP, форматтер) прописывается в списке Зависимости и в
   `init.sh` одновременно; установка (кроме шрифта) - только через `./init.sh`.
5. Ленивая загрузка: у каждого плагина свой триггер (event/keys/cmd/ft); плагинные хоткеи
   живут в keys-спеке, а не внутри config - иначе плагин грузится на старте.
6. Все кастомные хоткеи через package/keymaps (desc с префиксом `cfg:`) - иначе мапа не
   попадёт в словарь `<C-p>`.
7. Неиспользуемые фичи плагина отключаем явно (пример: daily_notes/slides/sync в
   obsidian).
8. Версии пинятся `lazy-lock.json`, файл коммитится.
9. Единый стиль float-окон: `border = single` (тема kanagawa, overrides для новых
   флоатов - туда же).
10. Гейт после правок: stylua по изменённым lua-файлам; headless-старт nvim без ошибок;
    smoke-проверка затронутого плагина; markdown - через nvim-пайплайн форматтера.
