line_number = ARGV[0].to_i 

require "bundler/setup"
Bundler.require
require "parser/ruby21"
require "shellwords"
require "pp"


code = File.read("commands").split("\n")[line_number]
code = code.rstrip
puts "#### #{code} ####"
puts "#### Shellwords #{Shellwords.shellsplit(code)}"

puts "---------------------------parser.parse-----------------------"
pp Parser::Ruby21.parse(code)

