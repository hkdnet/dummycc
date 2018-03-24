require 'spec_helper'

RSpec.describe DummyCC::Parser do
  describe '疎通確認用' do
    let(:parser) { DummyCC::Parser.new(tokens) }
    let(:tokens) do
      DummyCC::TokenStream.new.tap do |e|
        e << DummyCC::Token.new('', :eof, 1)
      end
    end

    it do
      expect(parser.exec).to be_a DummyCC::AST::TranslationUnit
    end
  end
end
