require 'spec_helper'

describe 'check_i18n' do
  let(:msg) { "'warning' messages should be decorated: eg tstr(message)" }

  context 'with fix disabled' do
    context 'function without translate function' do
      let(:code) { "warning('message')" }

      it 'should detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should create a warning' do
        expect(problems).to contain_warning(msg).on_line(1).in_column(1)
      end
    end

    context 'function with translate function' do
      let(:code) { "warning(tstr('message'))" }

      it 'should not detect any problems' do
        expect(problems).to have(0).problems
      end
    end
  end

  context 'with fix enabled' do
    before do
      PuppetLint.configuration.fix = true
    end

    after do
      PuppetLint.configuration.fix = false
    end

    context 'function without a translate function' do
      let(:code) { "warning('message')" }

      it 'should only detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the problem' do
        expect(problems).to contain_fixed(msg).on_line(1).in_column(1)
      end

      it 'should add a newline to the end of the manifest' do
        expect(manifest).to eq("warning(tstr('message'))")
      end
    end

    context 'function with translate function' do
      let(:code) { "warning(tstr('message'))" }

      it 'should not detect any problems' do
        expect(problems).to have(0).problems
      end

      it 'should not modify the manifest' do
        expect(manifest).to eq(code)
      end
    end
  end
end
