require 'spec_helper'

describe Fixy::Formatter::Numeric do
  let(:proxy) do
    Class.new do
      include Fixy::Formatter::Numeric
    end.new
  end

  describe '#format_numeric' do
    subject(:format_numeric) { proxy.format_numeric(input, length) }
    let(:length) { 10 }

    context 'when input is nil' do
      let(:input) { nil }
      it { is_expected.to eq('0' * length) }
    end

    context 'when input is non-numeric' do
      let(:input) { 'Not a num' }

      it 'raises an exception' do
        expect { format_numeric }.to raise_error(ArgumentError, /only digits/)
      end
    end

    context 'when input is too length' do
      let(:input) { ('5' * (length + 1)).to_i }

      it 'raises an exception' do
        expect { format_numeric }.to raise_error(ArgumentError, /length/)
      end
    end
  end
end
