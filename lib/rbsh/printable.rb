
module RBSH
  module Printable
    def fancy_type
      "#{self.class.to_s.split('::').last}"
    end

    def to_sexp(indent=0)
      indented = "| " * indent
      sexp = "#{indented}(#{fancy_type}"

      if respond_to?(:children)
        first_node_child = children.index do |child|
          child.respond_to?(:to_sexp) || child.is_a?(Array)
        end || children.count

        children.each_with_index do |child, idx|
          if child.respond_to?(:to_sexp) && idx >= first_node_child
            sexp += "\n#{child.to_sexp(indent + 1)}"
          else
            sexp += " #{child.inspect}"
          end
        end
      end

      sexp += ")"
      sexp
    end
  end
end