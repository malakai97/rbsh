require "rbsh/ast/expression"

module RBSH
  module AST

    class SingleQuotedString < Expression
      child :children, [Expression]
    end

  end
end
