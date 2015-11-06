
module RBSH
  class Token

    attr_reader :contents
    attr_reader :bracketed?
    attr_reader :quoted?

    def initialize(contents)
      @contents = contents
    end

    def to_s
      "#{self.class}(#{contents.to_s})"
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