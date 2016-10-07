module RBSH
  module Semantic

    class Assignment < Rubyable
      include RBSH::Printable
      def initialize(lhs, rhs)
        @lhs = lhs
        @rhs = rhs
      end

      def to_ruby
        "#{lhs.to_ruby} = #{rhs.to_ruby}"
      end

      private
      attr_reader :lhs, :rhs
    end

  end
end