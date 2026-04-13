-- Работа с обёртками вокруг текста: скобки, кавычки, теги
--
-- ys{motion}{char} — добавить обёртку:  ysiw"  →  "hello"
-- cs{old}{new}     — заменить обёртку:  cs"'   →  'hello'
-- ds{char}         — удалить обёртку:   ds"    →   hello
-- S{char}          — обернуть выделение (visual mode)
return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = true,
}
