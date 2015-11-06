
require "rbsh/token"

module RBSH
  class Parser
    ORDER = [
      :tokenize_strings,
      :tokenize_brackets
    ]

    # Look for pairs of quotes and convert their
    # contents to a single token.
    # @param string [String]
    # @return [Array<Token, QuoteToken>]
    def tokenize_strings(string)
      tokens = []
      all_tokens = split_on(string, '"')
      all_tokens.each_index do |i|
        if (i+1) % 2 == 0
          tokens << QuoteToken.new(all_tokens[i])
        else
          tokens << RBSH::Token.new(all_tokens[i])
        end
      end
      return tokens
    end

    # Look for the outermost pair of brackets
    # and convert their contents to a single token.
    # @param all_tokens [Array<Token,QuoteToken>]
    # @return [Array<Token,QuoteToken,BracketToken>]
    def tokenize_brackets(all_tokens)
      tokens = []
      all_tokens.each do |token|
        next if token.quoted?
        token.contents.split(/(#?\{.*\})/).each do |string_sub_token|
          if string_sub_token.end_with?("}")
            tokens << BracketToken.new(string_sub_token)
          else
            tokens << RBSH::Token.new(string_sub_token)
          end
        end
      end

      return tokens
    end


    def split_on(string, char)
      char_indexes = []
      bracket_balance = 0

      for i in (0..string.length-1) do
        case string[i]
          when "{"
            bracket_balance += 1
          when "}"
            bracket_balance -= 1
          when char
            if bracket_balance == 0
              char_indexes << i
            end
        end
      end

      stanzas = [string.slice(0, (char_indexes[0] || string.length)).strip]
      char_indexes.each_index do |i|
        start = char_indexes[i] + 1
        stop = (char_indexes[i+1] || string.length) - start
        stanzas << string.slice(start, stop).strip
      end

      return stanzas
    end





    def blah_when_open(string)
      for i in (0..string.length-1) do

      end

    end

    def blah(string, is_open)
      tokens = []
      current_token = ""
      for i in (0..string.length-1)
        if string[i] == '"'
          if is_open
            is_open = false
            tokens << current_token
            current_token = ""
          else
            is_open = true
            tokens << current_token unless current_token.empty?
            current_token = ""
          end
        else
          current_token << string[i]
        end
      end

      return tokens
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