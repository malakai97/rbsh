require "rltk/ast"

module RBSH
  module Syntax
    module AST

      class Node < RLTK::ASTNode
        include RBSH::Printable
      end

      class ClauseElement < Node; end
      class And < ClauseElement; end
      class Or < ClauseElement; end
      class Expression < Node; end

      class PipelineElement < Node
        child :children, [Expression]
      end

      class Pipeline < ClauseElement
        child :children, [PipelineElement]
      end

      class ClauseList < Node
        child :children, [ClauseElement]
      end


      class Parent < Expression
        child :children, [Expression]
      end

      class Terminal < Expression
        value :value, String

        def fancy_type
          "#{super}[#{value}]"
        end
      end

      class Subshell < Parent; end
      class Interpolation < Parent; end
      class SingleQuotedString < Parent; end
      class DoubleQuotedString < Parent; end
      class CurlyBraced < Parent; end
      class Bracketed < Parent; end
      class Parenthetical < Parent; end

      class Word < Terminal; end
      class Escaped < Terminal; end
      class Whitespace < Terminal; end

      class Equals < Expression; end

      class Assignment < Expression
        child :lhs, Word
        child :rhs, Expression
      end


    end

  end
end