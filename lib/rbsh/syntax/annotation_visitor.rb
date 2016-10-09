module RBSH
  module Syntax

    module AST
      class Node
        def accept(visitor)
          method_name = "visit_#{self.class.to_s.split("::").last}".to_sym
          visitor.public_send(method_name, self)
        end
      end
    end


    class AnnotationVisitor
      def visit_And(node)
        AST::And.new(node.lhs.accept(self), node.rhs.accept(self))
      end

      def visit_Assignment(node)
        AST::Assignment.new(node.lhs.accept(self), node.rhs.accept(self))
      end

      def visit_Bracketed(node)
        if node.parent.is_a?(AST::Assignment) || node.parent.is_a?(AST::PipelineElement)
          AST::Bracketed.new [AST::Word.new(children_to_word(node.children))]
        else
          AST::Word.new "[#{children_to_word(node.children)}]"
        end
      end

      def visit_CurlyBraced(node)
        if node.parent.is_a?(AST::Assignment) || node.parent.is_a?(AST::PipelineElement)
          AST::CurlyBraced.new [AST::Word.new(children_to_word(node.children))]
        else
          AST::Word.new "{#{children_to_word(node.children)}}"
        end
      end

      def visit_DoubleQuotedString(node)
        if node.parent.is_a?(AST::Assignment) || node.parent.is_a?(AST::PipelineElement)
          AST::DoubleQuotedString.new [AST::Word.new(children_to_word(node.children))]
        else
          AST::Word.new "\"#{children_to_word(node.children)}\""
        end
      end

      def visit_Equals(node)
        AST::Word.new(node.value)
      end

      def visit_Escaped(node)
        AST::Word.new(node.value)
      end

      def visit_Interpolation(node)
        if node.parent.is_a?(AST::Assignment) || node.parent.is_a?(AST::PipelineElement)
          AST::Interpolation.new [AST::Word.new(children_to_word(node.children))]
        else
          AST::Word.new '#{' + children_to_word(node.children) + '}'
        end
      end

      def visit_Or(node)
        AST::Or.new(node.lhs.accept(self), node.rhs.accept(self))
      end

      def visit_Parenthetical(node)
        content = node.children
          .map{|c| c.accept(self) }
          .map{|c| c.value }
          .join(" ")
        AST::Word.new("(#{content})")
      end

      def visit_Pipeline(node)
        children = node.children.map{|child| child.accept(self) }
        AST::Pipeline.new(children)
      end

      def visit_PipelineElement(node)
        children = node.children.map{|child| child.accept(self) }
        AST::PipelineElement.new(children)
      end

      def visit_SingleQuotedString(node)
        if node.parent.is_a?(AST::Assignment) || node.parent.is_a?(AST::PipelineElement)
          AST::SingleQuotedString.new [AST::Word.new(children_to_word(node.children))]
        else
          AST::Word.new "'#{children_to_word(node.children)}'"
        end
      end

      def visit_Subshell(node)
        if node.parent.is_a?(AST::Assignment) || node.parent.is_a?(AST::PipelineElement)
          AST::Subshell.new [AST::Word.new(children_to_word(node.children))]
        else
          AST::Word.new "`#{children_to_word(node.children)}`"
        end
      end

      def visit_Then(node)
        AST::Then.new(node.lhs.accept(self), node.rhs.accept(self))
      end

      def visit_Whitespace(node)
        AST::Word.new(node.value)
      end

      def visit_Word(node)
        AST::Word.new(node.value)
      end

      private

      def children_to_word(children)
        children
          .map{|c| c.accept(self) }
          .map{|c| c.value }
          .join
      end

    end


  end
end