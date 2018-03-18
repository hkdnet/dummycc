require 'spec_helper'

RSpec.describe DummyCC::Parser do
  let(:parser) { DummyCC::Parser.new(text) }
  let(:tokens) { parser.parse }

  describe '行コメント' do
    let(:text) do
      <<-EOS
      int
      // a
      int
      EOS
    end

    it do
      expect(tokens.instance_variable_get('@tokens')).to eq [
        DummyCC::Token.new('int', :int, 1),
        DummyCC::Token.new('int', :int, 3),
        DummyCC::Token.new('', :eof, 3),
      ]
    end
  end
end
