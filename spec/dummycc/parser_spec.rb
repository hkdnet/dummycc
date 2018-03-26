require 'spec_helper'

RSpec.describe DummyCC::Parser do
  describe '疎通確認用' do
    subject(:tu) { parser.exec }

    let(:parser) { DummyCC::Parser.new(tokens) }
    let(:tokens) do
      DummyCC::Lexer.new(text).parse
    end
    let(:text) do
      <<-EOS
int foo(int arg);
int bar(int arg1) {
  return 1;
}
      EOS
    end

    it do
      expect(tu.proto_at(1)).to be_nil

      foo_proto = tu.proto_at(0)
      expect(foo_proto.name).to eq 'foo'
      expect(foo_proto.param_name_at(0)).to eq 'arg'
      expect(foo_proto.param_name_at(1)).to be_nil

      expect(tu.func_at(1)).to be_nil

      bar_func = tu.func_at(0)
      expect(bar_func.name).to eq 'bar'
      bar_proto = bar_func.proto
      expect(bar_proto.param_name_at(0)).to eq 'arg1'
      expect(bar_proto.param_name_at(1)).to be_nil
    end
  end
end
