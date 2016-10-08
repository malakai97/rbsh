require "rbsh/syntax/ast/element"

ns 'r_b_s_h.syntax.a_s_t' do
  class Pair < Element
    child :lhs, Element
    child :rhs, Element
  end
end
