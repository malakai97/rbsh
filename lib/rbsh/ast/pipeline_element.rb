require "rbsh/ast/node"
require "rbsh/ast/expression"

module RBSH
  module AST

    class PipelineElement < Node
      child :children, [Expression]
    end

  end
end
