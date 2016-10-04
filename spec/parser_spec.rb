require "spec_helper"

class Token < Struct.new(:type, :value)
end




module RBSH
  describe Parser do
    let(:parser) { described_class.new }
    describe "#parse_word" do
      let(:string) { 'f-!' }
      let(:tokens) {
        [Token.new(:WORD, 'f-!')]
      }
      it "handles tokens" do
        expect(parser.parse_word("", tokens)[0]).to eql(string)
      end
      it "expires tokens it uses" do
        expect(parser.parse_word("", tokens)[1]).to eql([])
      end
    end
    describe "#parse_single_quote" do
      let(:string) { %w('"oo"')[0] }
      let(:tokens) { [
        Token.new(:SINGLE_QUOTE_START, "'"),
        Token.new(:DOUBLE_QUOTE_START, '"'),
        Token.new(:CHAR, 'o'),
        Token.new(:CHAR, 'o'),
        Token.new(:DOUBLE_QUOTE_END, '"'),
        Token.new(:SINGLE_QUOTE_END, "'")
        ]
      }
      it "handles stuff" do
        expect(parser.parse_single_quote("", tokens)[0]).to eql(string)
      end
      it "expires tokens it uses" do
        expect(parser.parse_single_quote("", tokens)[1]).to eql([])
      end
    end
    describe "#parse_double_quote" do
      let(:simple_string) { '"foo"'}
      let(:simple_tokens) { [
        Token.new(:DOUBLE_QUOTE_START, '"'),
        Token.new(:CHAR, 'f'),
        Token.new(:CHAR, 'o'),
        Token.new(:CHAR, 'o'),
        Token.new(:DOUBLE_QUOTE_END, '"')
        ]
      }
      let(:interpolated_string) { '"1#{"2"}"' }
      let(:interpolated_tokens) {
        [
          Token.new(:DOUBLE_QUOTE_START, '"'),
          Token.new(:CHAR, "1"),
          Token.new(:INTERPOLATE_START, '#{'),
          Token.new(:DOUBLE_QUOTE_START, '"'),
          Token.new(:CHAR, "2"),
          Token.new(:DOUBLE_QUOTE_END, '"'),
          Token.new(:INTERPOLATE_END, '}'),
          Token.new(:DOUBLE_QUOTE_END, '"')
        ]
      }

      it "handles simple" do
        expect(parser.parse_double_quote("", simple_tokens)[0]).to eql(simple_string)
      end
      it "handled nesting" do
        expect(parser.parse_double_quote("", interpolated_tokens)[0]).to eql(interpolated_string)
      end
      it "expires the tokens it uses" do
        expect(parser.parse_double_quote("", interpolated_tokens)[1]).to eql([])
      end
    end
  end
end