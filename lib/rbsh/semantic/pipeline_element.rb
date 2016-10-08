module RBSH
  module Semantic

    # A pipeline element contains either straight ruby
    # code, a system command without ruby, or a mixture
    # of the two beginning with a system command.
    #
    # Pipeline elements may begin with any number of
    # assignments.
    class PipelineElement < Container

      attr_accessor :stdin, :stdout, :stderr

      def to_ruby
        children.map{|e| e.to_ruby }.join(" ")
      end
    end

  end
end