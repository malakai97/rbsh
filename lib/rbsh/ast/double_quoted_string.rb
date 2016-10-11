require "rbsh/ast/expression"

module RBSH
  module AST

    class DoubleQuotedString < Expression
      child :children, [Expression]
    end

  end
end
