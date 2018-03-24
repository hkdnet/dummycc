require 'spec_helper'

RSpec.describe DummyCC::AST::VariableDecl do
  describe '#initialize' do
    context 'with invalid type' do
      it do
        expect {
          DummyCC::AST::VariableDecl.new('name', :invalid_type)
        }.to raise_error DummyCC::UnknownDeclTypeError
      end
    end
  end
end

