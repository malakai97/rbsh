require "rbsh/ast/element"
require "rbsh/ast/pipeline_element"

module RBSH
  module AST

    class Pipeline < Element
      child :children, [PipelineElement]
    end

  end
end
