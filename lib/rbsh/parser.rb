

module RBSH

  # Takes an array of tokens from the lexer and parses
  # them into logical units.  These units can then be
  # resolved to semantic objects within a pipeline.
  class Parser

    # Given an array of tokens, produce
    # an array of arrays of logical units with
    # all nesting resolved.
    def parse(tokens)
      current_pipe = []
      pipeline = []
      until tokens.empty?
        if tokens.first.type == :PIPE
          pipeline << current_pipe
          current_pipe = []
          tokens = tokens.drop(1)
        else
          subclause, new_tokens = parse_next(tokens)
          tokens = new_tokens
          current_pipe << subclause
        end
      end
      pipeline << current_pipe
      return pipeline
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
      when :WORD
        parse_word("", tokens)
      when :WHITESPACE
        parse_whitespace("", tokens)
      when :EQUALS
        ["=", tokens.drop(1)]
      when :EOS #the end of stream character
        ["", []]
      end

    end

    # Parse consecutive whitespace.
    def parse_whitespace(active, tokens)
      return active, tokens if tokens.empty?
      if tokens.first.type == :WHITESPACE
        active << tokens.first.value
        parse_whitespace active, tokens.drop(1)
      else
        [active, tokens]
      end
    end

    # Parse a word
    # @param active The active token
    # @param tokens The array of tokens with which to construct
    #   the word.  Should not include used tokens.
    # @return [word, tokens] The word and the yet-unused tokens.
    def parse_word(active, tokens)
      [tokens.first.value, tokens.drop(1)]
    end


    # Anything in single quotes is part of that string
    def parse_single_quote(active, tokens)
      loop do
        break if tokens.empty?
        active << tokens.first.value
        type = tokens.first.type
        tokens = tokens.drop(1)
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
        tokens = tokens.drop(1)
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