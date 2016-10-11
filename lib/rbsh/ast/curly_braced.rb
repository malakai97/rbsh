require "rbsh/ast/expression"

module RBSH
  module AST

    class CurlyBraced < Expression
      child :children, [Expression]
    end

  end
end
