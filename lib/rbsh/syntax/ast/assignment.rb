require "rbsh/syntax/ast/expression"
require "rbsh/syntax/ast/word"

ns 'r_b_s_h.syntax.a_s_t' do
  class Assignment < Expression
    child :lhs, Word
    child :rhs, Expression
  end
end
