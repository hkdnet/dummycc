require 'spec_helper'

RSpec.describe DummyCC::Token do
  describe '#initialize' do
    context 'invalid type' do
      it { expect { DummyCC::Token.new('a', :invalid, 1) }.to raise_error DummyCC::Token::UnknownTypeError }
    end
  end
end
