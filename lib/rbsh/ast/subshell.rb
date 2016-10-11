require "rbsh/ast/expression"

module RBSH
  module AST

    class Subshell < Expression
      child :children, [Expression]
    end

  end
end
