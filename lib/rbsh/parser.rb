

module RBSH
  class Parser



    # Mostly we are just identifying things.  We will let ruby handle them.
    # Ruby handles:
    #  - anything in a double quoted string, including interpolation subshells, etc
    #  - anything in a single quoted string
    #  - anything in a curly brace
    #  - anything in brackets
    #  - anything in a backticks, again we're just doing this work to find its end.

    def initialize(tokens)
      @tokens = tokens
      @index = 0
      @active = nil
      @output = []
    end


    # parse the next token
    def parse_next(tokens)
      case tokens.first.type
      when :SINGLE_QUOTE_START
        parse_single_quote("", tokens)
      when :DOUBLE_QUOTE_START
        parse_double_quote("", tokens)
      when :SUBSHELL_START
        parse_subshell("", tokens)
      when :CURLY_BRACE_START
        parse_curly_brace("", tokens)
      when :BRACKET_START
        parse_bracket("", tokens)
      when :CHAR
        parse_word("", tokens)
      when :WHITESPACE
        parse(tokens[1..-1])
      end

    end

    # Parse a word
    # @param active The active token
    # @param tokens The array of tokens with which to construct
    #   the word.  Should not include used tokens.
    # @return [word, tokens] The word and the yet-unused tokens.
    def parse_word(active, tokens)
      return active, tokens if tokens.empty?
      if tokens.first.type == :CHAR
        parse_word(active + tokens.first.value, tokens[1..-1])
      else
        [active, tokens]
      end
    end


    # Anything in single quotes is part of that string
    def parse_single_quote(active, tokens)
      loop do
        break if tokens.empty?
        active << tokens.first.value
        type = tokens.first.type
        tokens = tokens[1..-1]
        break if type == :SINGLE_QUOTE_END
      end
      return active, tokens
    end

    def parse_subshell(active, tokens)
      parse_nestable active, tokens, :SUBSHELL_START, :SUBSHELL_END
    end

    # Parse a double-quoted string
    # the first token should be the :DOUBLE_QUOTE_START
    def parse_double_quote(active, tokens)
      parse_nestable active, tokens, :DOUBLE_QUOTE_START, :DOUBLE_QUOTE_END
    end

    # Anything in a curly brace is ruby code
    def parse_curly_brace(active, tokens)
      parse_nestable active, tokens, :CURLY_BRACE_START, :CURLY_BRACE_END
    end

    # Anything in a bracket is ruby code
    def parse_bracket(active, tokens)
      parse_nestable active, tokens, :BRACKET_START, :BRACKET_END
    end


    def parse_nestable(active, tokens, start_type, stop_type)
      nesting = 0
      loop do
        break if tokens.empty?
        case tokens.first.type
        when start_type
          nesting += 1
        when stop_type
          nesting -= 1
        end
        active << tokens.first.value
        tokens = tokens[1..-1]
        break if nesting == 0
      end
      return active, tokens
    end





    private

    # Cross-platform way of finding an executable in the $PATH.
    # Stolen from http://mislav.net/ via stackoverflow
    #
    #   which('ruby') #=> /usr/bin/ruby
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      return nil
    end

  end
end