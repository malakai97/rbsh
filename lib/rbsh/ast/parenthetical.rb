require "rbsh/ast/expression"

module RBSH
  module AST

    class Parenthetical < Expression
      child :children, [Expression]
    end

  end
end
