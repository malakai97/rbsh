require "rbsh/ast/expression"
require "rbsh/ast/word"

module RBSH
  module AST

    class Assignment < Expression
      child :lhs, Word
      child :rhs, Expression
    end

  end
end
