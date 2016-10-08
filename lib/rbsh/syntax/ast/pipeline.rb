require "rbsh/syntax/ast/element"
require "rbsh/syntax/ast/pipeline_element"

ns 'r_b_s_h.syntax.a_s_t' do
  class Pipeline < Element
    child :children, [PipelineElement]
  end
end
