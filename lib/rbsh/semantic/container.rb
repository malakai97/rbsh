module RBSH
  module Semantic

    class Container
      include RBSH::Printable

      attr_reader :children

      def initialize(children)
        @children = children
      end
    end

  end
end