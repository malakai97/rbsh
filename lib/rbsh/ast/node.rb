require "rltk/ast"

module RBSH
  module AST

    class Node < RLTK::ASTNode
      include RBSH::Printable
    end

  end
end
