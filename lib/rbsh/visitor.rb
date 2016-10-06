module RBSH

  module AST
    class Node
      def accept(visitor)
        method_name = "visit_#{self.class.to_s.split("::").last}".to_sym
        visitor.public_send(method_name, self)
      end
    end
  end

  class Container
    attr_reader :elements
    def initialize(elements)
      @elements = elements
    end
  end

  class Content
    attr_reader :content
    def initialize(content)
      @content = content
    end
  end

  class Pipeline < Container; end
  class PipelineElement < Container
    def to_ruby
      elements.map{|e| e.to_ruby }.join(" ")
    end
  end
  class Subshell < Content
    def to_ruby
      "`#{content}`"
    end
  end
  class Interpolation < Content
    def to_ruby
      '#{' + content + '}'
    end
  end
  class SingleQuotedString < Content
    def to_ruby
      "'#{content}'"
    end
  end
  class DoubleQuotedString < Content
    def to_ruby
      '"' + content + '"'
    end
  end
  class CurlyBraced < Content
    def to_ruby
      "{#{content}}"
    end
  end
  class Bracketed < Content
    def to_ruby
      "[#{content}]"
    end
  end
  class Parenthetical < Content
    def to_ruby
      "(#{content})"
    end
  end
  class Word < Content
    def to_ruby
      content
    end
  end
  class Assignment
    attr_reader :lhs, :rhs
    def initialize(lhs, rhs)
      @lhs = lhs
      @rhs = rhs
    end
    def to_ruby
      "#{lhs.to_ruby} = #{rhs.to_ruby}"
    end
  end

  class Visitor

    def visit_Pipeline(node)
      children = node.children.map{|child| child.accept(self) }
      Pipeline.new(children)
    end

    def visit_PipelineElement(node)
      children = node.children.map{|child| child.accept(self) }
      PipelineElement.new(children)
    end

    def visit_Subshell(node)
      Subshell.new(children_to_content(node.children))
    end

    def visit_Interpolation(node)
      Interpolation.new(children_to_content(node.children))
    end

    def visit_SingleQuotedString(node)
      SingleQuotedString.new(children_to_content(node.children))
    end

    def visit_DoubleQuotedString(node)
      DoubleQuotedString.new(children_to_content(node.children))
    end

    def visit_CurlyBraced(node)
      CurlyBraced.new(children_to_content(node.children))
    end

    def visit_Bracketed(node)
      Bracketed.new(children_to_content(node.children))
    end

    def visit_Parenthetical(node)
      content = node.children
        .map{|child| child.accept(self) }
        .map{|child| child.to_ruby }
        .join(" ")
      Word.new("(#{content})")
    end

    def visit_Word(node)
      Word.new(node.value)
    end

    def visit_Escaped(node)
      Word.new(node.value)
    end

    def visit_Whitespace(node)
      Word.new(node.value)
    end

    def visit_Equals(node)
      Word.new(node.value)
    end

    def visit_And(node)
      Word.new(node.value)
    end

    def visit_Or(node)
      Word.new(node.value)
    end

    def visit_Assignment(node)
      Assignment.new(node.lhs.accept(self), node.rhs.accept(self))
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