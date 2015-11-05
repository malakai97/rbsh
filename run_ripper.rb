require "bundler/setup"
Bundler.require
require "parser/ruby21"
require "ripper"
require "shellwords"
require "pp"

def main
  line_number = ARGV[0].to_i - 1
  code = File.read("commands").split("\n")[line_number]
  code = code.rstrip

  puts "#### #{code} ####"

  code = standardize_equals(code)
  puts "#### fixed equals: #{code}"
  unpiped = split_on_pipes(code)
  puts "#### split_on_pipes: #{unpiped}"
  # puts "#### Ripper.tokenize: \n####   #{Ripper.tokenize(code)}"

  unpiped.each do |token|
    puts "token: #{token}"
    puts "#### Ripper.tokenize: #{Ripper.tokenize(token)}"
    puts "---------------------------ripper.lex-----------------------"
    pp Ripper.lex(token)
    puts "---------------------------parser.parse-----------------------"
    begin
      pp Parser::Ruby21.parse(token)
    rescue Parser::SyntaxError
    end
  end

end


def split_out_assignments(string)

end


def standardize_equals(string)
  string.gsub(/([^=])[\s]*((==|=))[\s]*([^=])/, '\1\2\4')
end

def fix_first_assignment(symbol, scope)
  if symbol.to_s.include?("@")
    instance_variable_set(symbol, instance_variable_get(symbol)[0])
  else
    scope.local_variable_set(symbol, scope.local_variable_get(symbol)[0])
  end
end


def split_on_pipes(string)
  pipe_indexes = []
  bracket_balance = 0

  for i in (0..string.length-1) do
    case string[i]
      when "{"
        bracket_balance += 1
      when "}"
        bracket_balance -= 1
      when "|"
        if bracket_balance == 0
          pipe_indexes << i
        end
    end
  end

  stanzas = [string.slice(0, (pipe_indexes[0] || string.length)).strip]
  pipe_indexes.each_index do |i|
    start = pipe_indexes[i] + 1
    stop = (pipe_indexes[i+1] || string.length) - start
    stanzas << string.slice(start, stop).strip
  end

  return stanzas
end

main()