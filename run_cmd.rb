line_number = ARGV[0].to_i 

require "irb"
require "pp"


code = File.read("commands").split("\n")[line_number]
puts "#### #{code} ####"

puts "---------------------irb.rubylex.lex-----------------------------"
pp RubyLex.new.lex(code.strip)


puts "---------------------irb.slex.lex-----------------------------"
pp IRB::SLex.new.lex(code.strip)
