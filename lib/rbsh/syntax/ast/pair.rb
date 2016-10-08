require "rbsh/syntax/ast/element"

module RBSH
  module Syntax
    module AST

      class Pair < Element
        child :lhs, Element
        child :rhs, Element
      end

    end
  end
end
