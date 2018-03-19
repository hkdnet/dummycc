require 'spec_helper'

RSpec.describe DummyCC::TokenStream do
  let(:tokens) { DummyCC::TokenStream.new }

  describe '#initialize' do
    describe '#cur' do
      it { expect(tokens.cur).to eq 0 }
    end
  end

  describe '#next' do
    context 'with no args' do
      it { expect { tokens.next }.to change { tokens.cur }.by(1) }
    end

    context 'with an arg' do
      it { expect { tokens.next(2) }.to change { tokens.cur }.by(2) }
    end
  end

  describe '#token' do
    let(:token1) { DummyCC::Token.new('int', :int, 1) }
    let(:token2) { DummyCC::Token.new('i', :identifier, 1) }
    let(:token3) { DummyCC::Token.new(';', :symbol, 1) }
    let(:token4) { DummyCC::Token.new('', :eof, 2) }

    before do
      tokens << token1
      tokens << token2
      tokens << token3
      tokens << token4
    end

    it 'returns token at cur' do
      expect(tokens.token).to eq token1
      tokens.next
      expect(tokens.token).to eq token2
      tokens.next(2)
      expect(tokens.token).to eq token4
      tokens.prev
      expect(tokens.token).to eq token3
    end

    context 'invalid index' do
      it do
        tokens.prev
        expect { tokens.token }.to raise_error DummyCC::IndexError
      end
    end
  end
end
