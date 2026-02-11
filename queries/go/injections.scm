; extends

; 1. Короткое объявление (query := `...` или query := "...")
((short_var_declaration
  left: (expression_list (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]"))
  right: (expression_list 
    [
      (raw_string_literal (raw_string_literal_content) @injection.content)
      (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
    ]))
  (#set! "injection.language" "sql"))

; 2. Внутри вызова функции (query := fmt.Sprintf("...", args))
((short_var_declaration
  left: (expression_list (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]"))
  right: (expression_list 
    (call_expression 
      arguments: (argument_list 
        [
          (raw_string_literal (raw_string_literal_content) @injection.content)
          (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
        ]))))
  (#set! "injection.language" "sql"))

; 3. Переменные и константы (var/const query = "...")
((var_spec
  name: (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]")
  value: (expression_list 
    [
      (raw_string_literal (raw_string_literal_content) @injection.content)
      (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
    ]))
  (#set! "injection.language" "sql"))

((const_spec
  name: (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]")
  value: (expression_list 
    [
      (raw_string_literal (raw_string_literal_content) @injection.content)
      (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
    ]))
  (#set! "injection.language" "sql"))

