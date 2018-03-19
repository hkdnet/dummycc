require 'spec_helper'

RSpec.describe DummyCC::TokenStream do
  let(:tokens) { DummyCC::TokenStream.new }

  describe '#initialize' do
    describe '#cur' do
      it { expect(tokens.cur).to eq 0 }
    end
  end
end
