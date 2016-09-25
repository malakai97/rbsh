require "bundler/setup"
require "rltk"

module RBSH

  class NewLexer



  end

  class Lexer < RLTK::Lexer

    # /=/ denotes assignment, should be passed to ruby
    #     but we have to support assignments separated by spaces
    # rule(/=/) { :EQUALS }

    # /[a-zA-Z_][a-zA-Z0-9_]*/ denotes a variable name

    rule(/\\/, :default)      { push_state(:escape); :BACKSLASH }
    rule(/`/, :default)       { push_state(:subshell); :SUBSHELL_START }
    rule(/"/, :default)       { push_state(:double_quote); :DOUBLE_QUOTE_START }
    rule(/'/, :default)       { push_state(:single_quote); :SINGLE_QUOTE_START }

    rule(/\\/, :single_quote) { push_state(:escape); :BACKSLASH }
    rule(/'/, :single_quote)  { pop_state; :SINGLE_QUOTE_END }

    rule(/\\/, :double_quote) { push_state(:escape) }
    rule(/"/, :double_quote)  { pop_state; :DOUBLE_QUOTE_END }
    rule(/[^\\]#\{/, :double_quote) { push_state(:interpolate); :INTERPOLATE_START }

    rule(/"/, :interpolate)   { push_state(:double_quote); :DOUBLE_QUOTE_START }
    rule(/'/, :interpolate)   { push_state(:single_quote); :SINGLE_QUOTE_START }
    rule(/\}/, :interpolate)  { pop_state; :INTERPOLATE_END }

    rule(/.|\s/, :escape)     {|c| pop_state; [:ESCAPED, '\\' + c] }

    rule(/\\/, :subshell)     { push_state(:escape); :BACKSLASH }
    rule(/`/, :subshell)      { pop_state; :SUBSHELL_END }
    rule(/[^\\]#\{/, :subshell) { push_state(:interpolate); :INTERPOLATE_START }
    rule(/"/, :subshell)      {|c| push_state(:double_quote); [:ANY, c] }
    rule(/'/, :subshell)      {|c| push_state(:single_quote); [:ANY, c] }

    [:default, :subshell, :interpolate, :double_quote, :single_quote].each do |state|
      rule(/.|\s/, state)     {|c| [:ANY, c] }
    end
  end

end



result =  RBSH::Lexer.new.lex('"che#{5.times("foo"}ese"')
puts result
require 'pry'; binding.pry