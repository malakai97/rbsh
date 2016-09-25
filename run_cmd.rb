require "bundler/setup"
Bundler.require
require_relative "./lib/rbsh"
require "pp"

def main
  if ARGV[0] == "all"
    File.readlines("commands").each do |line|
      line = line.rstrip
      puts "######## #{line} ########"
      result =  RBSH::Lexer.new.lex(line)
      puts result
    end
  else
    line_number = ARGV[0].to_i - 1
    line = File.read("commands").split("\n")[line_number]
    line = line.rstrip
    puts "######## #{line} ########"
    result =  RBSH::Lexer.new.lex(line)
    puts result

  end
end



main()