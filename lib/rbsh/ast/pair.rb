require "rbsh/ast/element"

module RBSH
  module AST

    class Pair < Element
      child :lhs, Element
      child :rhs, Element
    end

  end
end
