require "rbsh/ast/expression"

module RBSH
  module AST

    class Interpolation < Expression
      child :children, [Expression]
    end


  end
end
