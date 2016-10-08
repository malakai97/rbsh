require "rbsh/syntax/ast/node"
require "rbsh/syntax/ast/expression"

module RBSH
  module Syntax
    module AST

      class PipelineElement < Node
        child :children, [Expression]
      end

    end
  end
end
