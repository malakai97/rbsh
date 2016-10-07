

module RBSH
  module Syntax
    # Tokenizes a string from the command line.
    class Lexer < RLTK::Lexer

      rule(/\\/, :default)      { push_state(:escape) }
      rule(/`/, :default)       { push_state(:subshell); [:SUBSHELL_START, '`'] }
      rule(/"/, :default)       { push_state(:double_quote); [:DOUBLE_QUOTE_START, '"'] }
      rule(/'/, :default)       { push_state(:single_quote); [:SINGLE_QUOTE_START, "'"] }
      rule(/\|/, :default)      { :PIPE }
      rule(/\{/, :default)      { push_state(:curly_brace); [:CURLY_BRACE_START, "{"] }
      rule(/\[/, :default)      { push_state(:bracket); [:BRACKET_START, "["] }
      rule(/=/, :default)       { [:EQUALS, '='] }
      rule(/&&/, :default)      { [:AND, '&&']}
      rule(/\|\|/, :default)    { [:OR, '||']}
      rule(/,/, :default)       { [:COMMA, ',']}
      rule(/;/, :default)       { [:SEMI, ';']}
      rule(/\(/, :default)      { push_state(:parenthesis); [:PAREN_START, '('] }

      rule(/\)/, :parenthesis)  { pop_state; [:PAREN_END, ')'] }
      rule(/`/, :parenthesis)   { push_state(:subshell); [:SUBSHELL_START, '`'] }
      rule(/"/, :parenthesis)   { push_state(:double_quote); [:DOUBLE_QUOTE_START, '"'] }
      rule(/'/, :parenthesis)   { push_state(:single_quote); [:SINGLE_QUOTE_START, "'"] }
      rule(/\{/, :parenthesis)  { push_state(:curly_brace); [:CURLY_BRACE_START, "{"] }
      rule(/\[/, :parenthesis)  { push_state(:bracket); [:BRACKET_START, "["] }
      rule(/\(/, :parenthesis)  { push_state(:parenthesis); [:PAREN_START, '('] }

      rule(/\[/, :bracket)      { push_state(:bracket); [:BRACKET_START, "["] }
      rule(/\]/, :bracket)      { pop_state; [:BRACKET_END, "]" ]}
      rule(/"/, :bracket)       { push_state(:double_quote); [:DOUBLE_QUOTE_START, '"'] }
      rule(/'/, :bracket)       { push_state(:single_quote); [:SINGLE_QUOTE_START, "'"] }
      rule(/`/, :bracket)       { push_state(:subshell); [:SUBSHELL_START, '`'] }
      rule(/\{/, :bracket)      { push_state(:curly_brace); [:CURLY_BRACE_START, "{"] }

      rule(/\{/, :curly_brace)  { push_state(:curly_brace); [:CURLY_BRACE_START, "{"] }
      rule(/\}/, :curly_brace)  { pop_state; [:CURLY_BRACE_END, '}' ] }
      rule(/"/, :curly_brace)   { push_state(:double_quote); [:DOUBLE_QUOTE_START, '"'] }
      rule(/'/, :curly_brace)   { push_state(:single_quote); [:SINGLE_QUOTE_START, "'"] }
      rule(/`/, :curly_brace)   { push_state(:subshell); [:SUBSHELL_START, '`'] }
      rule(/\[/, :curly_brace)  { push_state(:bracket); [:BRACKET_START, "["] }

      rule(/\\/, :single_quote) { push_state(:escape) }
      rule(/'/, :single_quote)  { pop_state; [:SINGLE_QUOTE_END, "'"] }

      rule(/\\/, :double_quote) { push_state(:escape) }
      rule(/"/, :double_quote)  { pop_state; [:DOUBLE_QUOTE_END, '"'] }
      rule(/#\{/, :double_quote) { push_state(:interpolate); [:INTERPOLATE_START, '#{'] }

      rule(/`/, :interpolate)   { push_state(:subshell); [:SUBSHELL_START, '`'] }
      rule(/"/, :interpolate)   { push_state(:double_quote); [:DOUBLE_QUOTE_START, '"'] }
      rule(/'/, :interpolate)   { push_state(:single_quote); [:SINGLE_QUOTE_START, "'"] }
      rule(/\}/, :interpolate)  { pop_state; [:INTERPOLATE_END, '}'] }
      rule(/\{/, :interpolate)  { push_state(:curly_brace); [:CURLY_BRACE_START, "{"] }
      rule(/\[/, :interpolate)  { push_state(:bracket); [:BRACKET_START, "["] }

      rule(/.|\s/, :escape)     {|c| pop_state; [:ESCAPED, '\\' + c] }

      rule(/\\/, :subshell)     { push_state(:escape) }
      rule(/`/, :subshell)      { pop_state; [:SUBSHELL_END, '`'] }
      rule(/#\{/, :subshell)    { push_state(:interpolate); [:INTERPOLATE_START, '#{'] }
      rule(/"/, :subshell)      {|c| push_state(:double_quote); [:DOUBLE_QUOTE_START, c] }
      rule(/'/, :subshell)      {|c| push_state(:single_quote); [:SINGLE_QUOTE_START, c] }

      rule(/[^\s=\\'"`\[  { (  ,;]+/,   :default)       {|c| [:WORD, c] }
      rule(/[^\s   '"`\[  { ()   ]+/,   :parenthesis)   {|c| [:WORD, c] }
      rule(/[^\s   '"`\[\]{      ]+/,   :bracket)       {|c| [:WORD, c] }
      rule(/[^\s   '"`\[  {}     ]+/,   :curly_brace)   {|c| [:WORD, c] }
      rule(/[^\s \\'             ]+/,   :single_quote)  {|c| [:WORD, c] }
      rule(/[^\s \\ "         #  ]+/,   :double_quote)  {|c| [:WORD, c] }
      rule(/[^\s   '"`\[  {}     ]+/,   :interpolate)   {|c| [:WORD, c] }
      rule(/[^\s \\'"`        #  ]+/,   :subshell)      {|c| [:WORD, c] }

      rule(/\s+/, :default)                   { nil }
      rule(/\s+/, :parenthesis)               { nil }
      rule(/\s+/, :bracket)                   {|c| [:WHITESPACE, c] }
      rule(/\s+/, :curly_brace)               {|c| [:WHITESPACE, c] }
      rule(/\s+/, :single_quote)              {|c| [:WHITESPACE, c] }
      rule(/\s+/, :double_quote)              {|c| [:WHITESPACE, c] }
      rule(/\s+/, :interpolate)               {|c| [:WHITESPACE, c] }
      rule(/\s+/, :subshell)                  {|c| [:WHITESPACE, c] }
    end

  end

end
