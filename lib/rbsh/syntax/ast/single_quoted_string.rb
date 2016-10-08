require "rbsh/syntax/ast/expression"

module RBSH
  module Syntax
    module AST

      class SingleQuotedString < Expression
        child :children, [Expression]
      end

    end
  end
end
