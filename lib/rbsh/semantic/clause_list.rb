require "rbsh/semantic/container"

module RBSH
  module Semantic

    # A clause list is an array of pipelines, each
    # optionally separated by Semantic::And and
    # Semantic::Or
    class ClauseList < Container

      def evaluate(binding)
        iter = children.enum_for
        last_success = true
        loop do
          method_name = "evaluate_#{iter.next.class.to_s.downcase}".to_sym
          last_success = public_send(method_name, iter, last_success, binding)
        end
      end

      def evaluate_pipeline(iter, binding)
        iter.next.evaluate(binding)
      end

      def evaluate_and(iter, last_success, binding)
        iter.next
        if last_success
          iter.next.evaluate(binding)
        else
          iter.next
          false
        end
      end

      def evaluate_or(iter, last_success, binding)
        iter.next
        if last_success
          iter.next
          true
        else
          iter.next.evaluate(binding)
        end
      end



    end

  end
end