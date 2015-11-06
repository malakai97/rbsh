
module RBSH
  class Token

    attr_reader :contents


    def initialize(contents)
      @contents = contents
    end

    def bracketed?; false; end
    def quoted?; false; end

    def to_s
      class_name = self.class.to_s
      padding = Array.new( 18 - (class_name.length), "-").join("")
      "#{class_name}#{padding}(#{contents.inspect})"
    end

    def inspect
      to_s
    end
  end

  class BracketToken < Token
    def bracketed?
      true
    end
  end

  class QuoteToken < Token
    def quoted?
      true
    end
  end

end