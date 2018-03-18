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

  describe '/* コメント' do
    let(:text) do
      <<-EOS
      int
      /* a
      b
      c */
      int
      EOS
    end

    it do
      expect(tokens.instance_variable_get('@tokens')).to eq [
        DummyCC::Token.new('int', :int, 1),
        DummyCC::Token.new('int', :int, 5),
        DummyCC::Token.new('', :eof, 5),
      ]
    end
  end

  describe '1+1' do
    let(:text) { '1+1' }

    it do
      expect(tokens.instance_variable_get('@tokens')).to eq [
        DummyCC::Token.new('1', :digit, 1),
        DummyCC::Token.new('+', :symbol, 1),
        DummyCC::Token.new('1', :digit, 1),
        DummyCC::Token.new('', :eof, 1),
      ]
    end
  end

  describe 'int i;' do
    let(:text) { 'int i;' }

    it do
      expect(tokens.instance_variable_get('@tokens')).to eq [
        DummyCC::Token.new('int', :int, 1),
        DummyCC::Token.new('i', :identifier, 1),
        DummyCC::Token.new(';', :symbol, 1),
        DummyCC::Token.new('', :eof, 1),
      ]
    end
  end

  describe 'i = 10;' do
    let(:text) { 'i = 10;' }

    it do
      expect(tokens.instance_variable_get('@tokens')).to eq [
        DummyCC::Token.new('i', :identifier, 1),
        DummyCC::Token.new('=', :symbol, 1),
        DummyCC::Token.new('10', :digit, 1),
        DummyCC::Token.new(';', :symbol, 1),
        DummyCC::Token.new('', :eof, 1),
      ]
    end
  end
end
