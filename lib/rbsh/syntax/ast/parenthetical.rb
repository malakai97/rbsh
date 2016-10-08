require "rbsh/syntax/ast/expression"

module RBSH
  module Syntax
    module AST

      class Parenthetical < Expression
        child :children, [Expression]
      end

    end
  end
end
