require "rbsh/ast/expression"

module RBSH
  module AST

    class Bracketed < Expression
      child :children, [Expression]
    end

  end
end
