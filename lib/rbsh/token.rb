
module RBSH
  class Token

    attr_reader :contents


    def initialize(contents)
      @contents = contents
    end

    def bracketed?; false; end
    def quoted?; false; end

    def to_s
      "#{self.class.to_s}(#{contents.inspect})"
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