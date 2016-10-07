module RBSH
  module Semantic

    class PipelineElement < Container
      def to_ruby
        children.map{|e| e.to_ruby }.join(" ")
      end
    end

  end
end