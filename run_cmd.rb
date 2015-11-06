require "bundler/setup"
Bundler.require
require_relative "./lib/rbsh"
require "pp"

def main
  line_number = ARGV[0].to_i - 1
  code = File.read("commands").split("\n")[line_number]
  code = code.rstrip

  puts "#### #{code} ####"

  puts "--------------------------------------------------------------"
  parser = RBSH::Parser.new
  quoted = parser.tokenize_strings(code)
  pp quoted

  puts "--------------------------------------------------------------"
  bracketed = parser.tokenize_brackets(quoted)
  pp bracketed


end



main()