require "rbsh/syntax/ast/expression"

ns 'r_b_s_h.syntax.a_s_t' do
  class Terminal < Expression
    value :value, String

    def fancy_type
      "#{super}[#{value}]"
    end
  end
end
