require 'spec_helper'

RSpec.describe DummyCC::Parser do
  describe '疎通確認用' do
    let(:parser) { DummyCC::Parser.new(tokens) }
    let(:tokens) do
      DummyCC::Lexer.new(text).parse
    end
    let(:text) do
      <<-EOS
int foo(int arg);
int bar(int arg) {
  return 1;
}
      EOS
    end

    it do
      expect(parser.exec).to be_a DummyCC::AST::TranslationUnit
    end
  end
end
