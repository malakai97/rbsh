require "bundler/setup"
Bundler.require
require_relative "./lib/rbsh"
require "pp"

def main
  if ARGV[0] == "all"
    line_number = 0
    File.readlines("commands").each do |line|
      line_number += 1
      line = line.rstrip
      puts "\n######## #{line_number}: #{line} ########"
      result =  RBSH::Lexer.new.lex(line)
      ast = RBSH::Parser::parse(result)
      visitor = RBSH::Visitor.new
      pipeline = ast.accept(visitor)
      pp pipeline
    end
  else
    line_number = ARGV[0].to_i - 1
    line = File.read("commands").split("\n")[line_number]
    line = line.rstrip
    puts "######## #{line_number}: #{line} ########"
    lexed = RBSH::Lexer.new.lex(line)
    ast = RBSH::Parser::parse(lexed)
    visitor = RBSH::Visitor.new
    pipeline = ast.accept(visitor)
    pp pipeline
    require 'pry'; binding.pry
  end
end



main()