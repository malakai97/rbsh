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
      result =  RBSH::Syntax::Lexer.new.lex(line)
      ast = RBSH::Syntax::Parser::parse(result)
      visitor = RBSH::Syntax::AnnotationVisitor.new
      clauses = ast.accept(visitor)
      puts clauses.to_sexp
    end
  else
    line_number = ARGV[0].to_i - 1
    line = File.read("commands").split("\n")[line_number]
    line = line.rstrip
    puts "######## #{line_number}: #{line} ########"
    lexed = RBSH::Syntax::Lexer.new.lex(line)
    ast = RBSH::Syntax::Parser::parse(lexed)
    visitor = RBSH::Syntax::AnnotationVisitor.new
    clauses = ast.accept(visitor)
    puts clauses.to_sexp
  end
end



main()