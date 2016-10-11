require "rbsh/ast/expression"

module RBSH
  module AST

    class Terminal < Expression
      value :value, String

      def fancy_type
        "#{super}[#{value}]"
      end
    end

  end
end
