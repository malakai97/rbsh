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
  puts "#### Shellwords: #{Shellwords.shellsplit(code)}"
  puts "#### split_on_pipes: #{split_on_pipes(code)}"

  puts "---------------------------ripper.lex-----------------------"
  pp Ripper.lex(code)

  puts "---------------------------ripper.tokenize-----------------------"
  pp Ripper.tokenize(code)

  #puts "---------------------------ripper.parse-----------------------"
  #pp Ripper.parse(code)

  puts "---------------------------ripper.sexp_raw-----------------------"
  pp Ripper.sexp_raw(code)
end

def standardize_equals(string)
  string.gsub(/([^=])[\s]*((==|=))[\s]*([^=])/, '\1\2\4')
end

def split_on_pipes(_string)
  string = _string.dup
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