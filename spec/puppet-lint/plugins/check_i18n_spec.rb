require 'spec_helper'

describe 'check_i18n' do
  let(:msg) { "'warning' messages should be decorated: eg translate(message)" }
  let(:int_msg) { %r{interpolation is not supported} }
  let(:here_msg) { %r{heredoc detected} }

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

    context 'with ${} interpolation' do
      let(:code) { 'warning("a message: ${message}")' }

      it 'detects a problem' do
        expect(problems).to have(1).problems
      end

      it 'creates warning' do
        expect(problems[0][:message]).to match(int_msg)
      end

      it 'expects problem[:interpolation] to be true' do
        expect(problems[0][:interpolation]).to be_truthy
      end
    end

    context 'with $ interpolation' do
      let(:code) { 'warning("a message: $message")' }

      it 'detects a problem' do
        expect(problems).to have(1).problems
      end

      it 'creates warning' do
        expect(problems[0][:message]).to match(int_msg)
      end

      it 'expects problem[:interpolation] to be true' do
        expect(problems[0][:interpolation]).to be_truthy
      end
    end

    context 'with a heredoc' do
      let(:code) do
        'warning(@(EOL)
       this is a heredoc
       | EOL)'
      end

      it 'detects something' do
        expect(problems).to have(1).problems
      end

      it 'creates warning' do
        expect(problems[0][:message]).to match(here_msg)
      end

      it 'expects problem[:heredoc] to be true' do
        expect(problems[0][:heredoc]).to be_truthy
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

    context 'function without a translate function with interpolation' do
      let(:code) { 'warning("a message: ${message}")' }

      it 'onlies detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'adds a newline to the end of the manifest' do
        expect(manifest).not_to eq("warning(translate('message'))")
      end
    end

    context 'function without a translate function with a heredoc' do
      let(:code) do
        'warning(@(EOL)
       heredoc
       | EOL)'
      end

      it 'onlies detect a single problem' do
        expect(problems).to have(1).problem
      end

      it 'decorates the heredoc appropriately' do
        expect(manifest).to match(%r{warning\(translate\(@\(EOL\)\)})
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
