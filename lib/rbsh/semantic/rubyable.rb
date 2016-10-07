module RBSH
  module Semantic

    class Rubyable
      include RBSH::Printable
      def initialize(content)
        @content = content
      end

      private
      attr_reader :content

      def fancy_type
        "#{super}[#{to_ruby}]"
      end
    end

    class Subshell < Rubyable
      def to_ruby
        "`#{content}`"
      end
    end
    class Interpolation < Rubyable
      def to_ruby
        '#{' + content + '}'
      end
    end
    class SingleQuotedString < Rubyable
      def to_ruby
        "'#{content}'"
      end
    end
    class DoubleQuotedString < Rubyable
      def to_ruby
        '"' + content + '"'
      end
    end
    class CurlyBraced < Rubyable
      def to_ruby
        "{#{content}}"
      end
    end
    class Bracketed < Rubyable
      def to_ruby
        "[#{content}]"
      end
    end
    class Parenthetical < Rubyable
      def to_ruby
        "(#{content})"
      end
    end
    class Word < Rubyable
      def to_ruby
        content
      end
    end


  end
end