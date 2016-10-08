require "rbsh/syntax/ast/element"
require "rbsh/syntax/ast/pipeline_element"

module RBSH
  module Syntax
    module AST

      class Pipeline < Element
        child :children, [PipelineElement]
      end

    end
  end
end
