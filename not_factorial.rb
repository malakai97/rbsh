line_number = ARGV[0].to_i

require "ripper"
require "pp"


puts File.read("commands")
raw_code = File.read("commands").split("\n")[line_number]
puts "#### #{raw_code} ####"

count = 0
usable_tokens = []
code = raw_code.strip
tokens = []

5.times do
  puts "#{count += 1}: #{code}"
  if Ripper.sexp(code)
    usable_tokens << code
    break
  end

  tokens = Ripper.tokenize(code)
  pp tokens
  space_index = tokens.index(" ")
  unit = tokens.slice(0, space_index).join(" ").strip
  usable_tokens << unit
  code = code.slice(code.index(tokens[space_index + 1]), code.length)

  if code == ""
    puts "tokens empty"
    break
  end
end

pp "loop count is #{count}"
pp usable_tokens
usable_tokens.each do |token|
  puts "-------------#{token}-------------------------------"
  pp Ripper.lex(token)
end
