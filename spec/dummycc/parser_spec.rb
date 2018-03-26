require 'spec_helper'

RSpec.describe DummyCC::Parser do
  subject(:tu) { parser.exec }

  let(:parser) { DummyCC::Parser.new(tokens) }
  let(:tokens) do
    DummyCC::Lexer.new(text).parse
  end
  describe '疎通確認用' do
    let(:text) do
      <<-EOS
int foo(int arg);
int bar(int arg1, int arg2) {
  return 1;
}
      EOS
    end

    it 'proto' do
      expect(tu.proto_at(1)).to be_nil

      foo_proto = tu.proto_at(0)
      expect(foo_proto.name).to eq 'foo'
      expect(foo_proto.param_name_at(0)).to eq 'arg'
      expect(foo_proto.param_name_at(1)).to be_nil
    end

    it 'func' do
      expect(tu.func_at(1)).to be_nil

      bar_func = tu.func_at(0)
      expect(bar_func.name).to eq 'bar'
      bar_proto = bar_func.proto
      expect(bar_proto.param_name_at(0)).to eq 'arg1'
      expect(bar_proto.param_name_at(1)).to eq 'arg2'
      expect(bar_proto.param_name_at(2)).to be_nil
    end

    it 'func_body' do
      bar_func = tu.func_at(0)
      bar_body = bar_func.body
      expect(bar_body.variable_decl_at(0).name).to eq 'arg1'
      expect(bar_body.variable_decl_at(0).decl_type).to eq :param
      expect(bar_body.variable_decl_at(1).name).to eq 'arg2'
      expect(bar_body.variable_decl_at(1).decl_type).to eq :param
      expect(bar_body.variable_decl_at(2)).to be_nil
      stmt = bar_body.stmt_at(0)
      expect(stmt).to be_a DummyCC::AST::JumpStmt
      expect(stmt.expr).to eq DummyCC::AST::Number.new(1)
    end
  end

  describe 'ローカル変数宣言' do
    let(:text) do
      <<-EOS
int foo(int arg) {
  int ret;
  ret = 1;
  return ret;
}
      EOS
    end

    it 'proto' do
      foo = tu.func_at(0)
      foo_body = foo.body

      arg1 = foo_body.variable_decl_at(0)
      expect(arg1.name).to eq 'arg'
      expect(arg1.decl_type).to eq :param

      arg2 = foo_body.variable_decl_at(1)
      expect(arg2.name).to eq 'ret'
      expect(arg2.decl_type).to eq :local

      expect(foo_body.variable_decl_at(2)).to be_nil
    end
  end
end
