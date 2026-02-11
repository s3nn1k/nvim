; extends

((const_spec
  name: (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]")
  value: (expression_list (raw_string_literal (raw_string_literal_content) @injection.content)))
  (#set! "injection.language" "sql"))

((var_spec
  name: (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]")
  value: (expression_list (raw_string_literal (raw_string_literal_content) @injection.content)))
  (#set! "injection.language" "sql"))

((short_var_declaration
  left: (expression_list (identifier) @name (#match? @name "[qQ][uU][eE][rR][yY]"))
  right: (expression_list (raw_string_literal (raw_string_literal_content) @injection.content)))
  (#set! "injection.language" "sql"))
