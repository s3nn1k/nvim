# Neovim config

Персональный конфиг Neovim.

# Установка

Клонировать репозиторий в `~/.config/nvim`, запустить `./init.sh` - определит платформу и
позовёт нужный установщик из `scripts/`; то же самое руками - `make macos` или
`make fedora`. После - открыть Neovim, плагины установятся автоматически.

Обновление зависимостей и плагинов - тот же `./init.sh` (`make macos|fedora`), затем
`:Lazy update` внутри Neovim.

# Зависимости

Всё, кроме шрифта, ставится установщиком; список синхронен со скриптом платформы в
`scripts/`.

- macOS (`scripts/macos-bootstrap.sh`):
  - Утилиты (brew): neovim, gcc, make, ripgrep, git, tree-sitter-cli
  - Языки (brew): go, node, python, lua
  - LSP: brew - lua-language-server; npm - typescript, pyright, @mistweaverco/kulala-ls;
    go install - gopls
  - Форматтеры: brew - stylua, taplo, black; npm - prettier, sql-formatter; go install -
    goimports
- Fedora (`scripts/fedora-bootstrap.sh`):
  - Пакеты (dnf): neovim, gcc, make, ripgrep, git, tree-sitter-cli, golang, nodejs, npm,
    python3, pipx
  - LSP: npm - typescript, pyright, @mistweaverco/kulala-ls; go install - gopls; tarball с
    github (пакета в Fedora нет) - lua-language-server
  - Форматтеры: npm - prettier, sql-formatter, stylua, taplo; pipx - black; go install -
    goimports
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
   `scripts/<платформа>-bootstrap.sh` одновременно; установка (кроме шрифта) - только
   через `./init.sh` (`make macos|fedora`).
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

# Структура кода

- `lua/package/` - чистые модули: stdlib + встроенный vim API; require плагинов запрещён,
  зависимости передаются инъекцией из спеки.
- Интеграции с плагинами живут в `lua/plugins/<plugin>.lua` (config/keys спеки) или
  отдельным файлом домена (образец - `lua/themes/picker.lua`).
- `lua/core/` - wiring-слой: require плагинов допустим в ленивых замыканиях (пример -
  telescope.builtin в LspAttach-маппингах).
