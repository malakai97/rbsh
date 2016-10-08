module RBSH
  module Semantic

    # A pipeline is an array of one or more
    # Semantic::PipelineElements. The pipeline is
    # responsible for linking the stdout of one
    # element into the stdin of the one that follows
    # it.  It also provides an execution environment
    # for each element. In a sense, it is the workhorse.
    class Pipeline < Container



      def map_pipe_elements

      end

    end

  end
end