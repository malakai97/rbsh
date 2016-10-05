require "rltk/ast"

module RBSH

  module AST

    class Node < RLTK::ASTNode
      def fancy_type
        "#{self.class.to_s.split('::').last}"
      end

      def to_sexp(indent=0)
        indented = "| " * indent
        sexp = "#{indented}(#{fancy_type}"

        first_node_child = children.index do |child|
          child.is_a?(Node) || child.is_a?(Array)
        end || children.count

        children.each_with_index do |child, idx|
          if child.is_a?(Node) && idx >= first_node_child
            sexp += "\n#{child.to_sexp(indent + 1)}"
          else
            sexp += " #{child.inspect}"
          end
        end

        sexp += ")"

        sexp
      end

    end

    class Expression < Node; end

    class PipelineElement < Node
      child :children, [Expression]
    end

    class Pipeline < Node
      child :children, [PipelineElement]
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

    class Word < Terminal; end
    class Escaped < Terminal; end
    class Whitespace < Terminal; end

    class Equals < Expression; end
    class And < Expression; end
    class Or < Expression; end
  end

end