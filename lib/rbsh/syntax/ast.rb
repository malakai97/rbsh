require "rltk/ast"

Dir[File.join(File.dirname(__FILE__), 'ast', '*.rb')].each {|file| require file }