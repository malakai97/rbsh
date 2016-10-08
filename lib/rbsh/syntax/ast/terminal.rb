require "rbsh/syntax/ast/expression"

module RBSH
  module Syntax
    module AST

      class Terminal < Expression
        value :value, String

        def fancy_type
          "#{super}[#{value}]"
        end
      end

    end
  end
end
