require 'spec_helper'

RSpec.describe DummyCC::AST::CallExpr do
  describe '#arg_at' do
    let(:call_expr) { DummyCC::AST::CallExpr.new('foo', [1, 2, 3]) }

    it 'returns an arg' do
      expect(call_expr.arg_at(0)).to eq 1
    end

    context 'with invalid index' do
      it do
        expect { call_expr.arg_at(-1) }.to raise_error DummyCC::IndexError
      end
      it do
        expect { call_expr.arg_at(3) }.to raise_error DummyCC::IndexError
      end
    end
  end
end
