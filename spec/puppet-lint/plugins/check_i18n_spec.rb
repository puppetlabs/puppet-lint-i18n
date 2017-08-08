require 'spec_helper'

describe 'check_i18n' do
  let(:msg) { "'warning' messages should be decorated: eg translate(message)" }

  context 'with fix disabled' do
    context 'function without translate function' do
      let(:code) { "warning('message')" }

      it 'detects a single problem' do
        expect(problems).to have(1).problem
      end

      it 'creates a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(9)
      end
    end

    context 'function with translate function' do
      let(:code) { "warning(translate('message'))" }

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
      end
    end
  end

  context 'with fix enabled' do
    before(:each) do
      PuppetLint.configuration.fix = true
    end

    after(:each) do
      PuppetLint.configuration.fix = false
    end

    context 'function without a translate function' do
      let(:code) { "warning('message')" }

      it 'onlies detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'fixes the problem' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(9)
      end

      it 'adds a newline to the end of the manifest' do
        expect(manifest).to eq("warning(translate('message'))")
      end
    end

    context 'function with translate function' do
      let(:code) { "warning(translate('message'))" }

      it 'does not detect any problems' do
        expect(problems).to have(0).problems
      end

      it 'does not modify the manifest' do
        expect(manifest).to eq(code)
      end
    end
  end
end
