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

      def visit_ClauseList(node)
        children = node.children.map{|child| child.accept(self) }
        Semantic::ClauseList.new(children)
      end

      def visit_Pipeline(node)
        children = node.children.map{|child| child.accept(self) }
        Semantic::Pipeline.new(children)
      end

      def visit_PipelineElement(node)
        children = node.children.map{|child| child.accept(self) }
        Semantic::PipelineElement.new(children)
      end

      def visit_Subshell(node)
        Semantic::Subshell.new(children_to_content(node.children))
      end

      def visit_Interpolation(node)
        Semantic::Interpolation.new(children_to_content(node.children))
      end

      def visit_SingleQuotedString(node)
        Semantic::SingleQuotedString.new(children_to_content(node.children))
      end

      def visit_DoubleQuotedString(node)
        Semantic::DoubleQuotedString.new(children_to_content(node.children))
      end

      def visit_CurlyBraced(node)
        Semantic::CurlyBraced.new(children_to_content(node.children))
      end

      def visit_Bracketed(node)
        Semantic::Bracketed.new(children_to_content(node.children))
      end

      def visit_Parenthetical(node)
        content = node.children
          .map{|child| child.accept(self) }
          .map{|child| child.to_ruby }
          .join(" ")
        Semantic::Word.new("(#{content})")
      end

      def visit_Word(node)
        Semantic::Word.new(node.value)
      end

      def visit_Escaped(node)
        Semantic::Word.new(node.value)
      end

      def visit_Whitespace(node)
        Semantic::Word.new(node.value)
      end

      def visit_Equals(node)
        Semantic::Word.new(node.value)
      end

      def visit_And(node)
        Semantic::And.new
      end

      def visit_Or(node)
        Semantic::Or.new
      end

      def visit_Assignment(node)
        Semantic::Assignment.new(node.lhs.accept(self), node.rhs.accept(self))
      end


      private

      def children_to_content(children)
        children
          .map{|child| child.accept(self) }
          .map{|child| child.to_ruby }
          .join
      end


    end


  end
end