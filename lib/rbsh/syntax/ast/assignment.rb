require "rbsh/syntax/ast/expression"
require "rbsh/syntax/ast/word"

module RBSH
  module Syntax
    module AST

      class Assignment < Expression
        child :lhs, Word
        child :rhs, Expression
      end

    end
  end
end
