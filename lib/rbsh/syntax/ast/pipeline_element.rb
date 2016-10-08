require "rbsh/syntax/ast/node"
require "rbsh/syntax/ast/expression'"

ns 'r_b_s_h.syntax.a_s_t' do
  class PipelineElement < Node
    child :children, [Expression]
  end
end
