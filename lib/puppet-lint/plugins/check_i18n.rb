PuppetLint.new_check(:check_i18n) do
  TRANSLATE_FUNCTION = 'translate'.freeze
  STRINGY = Set[:STRING, :SSTRING, :DQPRE]
  FUNCTIONS_TO_BE_DECORATED = Set['warning', 'fail']
  def check
    tokens.select { |token| FUNCTIONS_TO_BE_DECORATED.include?(token.value) && function?(token) && message_not_decorated?(token) }.each do |token|
      function = token.value
      non_decorated_message = token.next_token.next_token

      interpolation = interpolation? non_decorated_message
      heredoc = heredoc? non_decorated_message

      message = if interpolation
                  "#{function}(#{non_decorated_message.value}) should be decorated but interpolation is not supported at this time."
                elsif heredoc
                  "'#{function}' messages should be decorated: eg #{TRANSLATE_FUNCTION}(#{non_decorated_message.value}) heredoc detected."
                else
                  "'#{function}' messages should be decorated: eg #{TRANSLATE_FUNCTION}(#{non_decorated_message.value})"
                end

      notify :warning, message: message,
                       line: token.line,
                       column: non_decorated_message.column,
                       token: non_decorated_message,
                       interpolation: interpolation,
                       heredoc: heredoc
    end
  end

  def fix(problem)
    return if problem[:interpolation]

    left_index = tokens.index(problem[:token])
    right_index = if problem[:heredoc]
                    tokens.index(problem[:token].find_token_of(:next, :NEWLINE, skip_blocks: true) || problem[:token].find_token_of(:next, :WHITESPACE, skip_blocks: true))
                  else
                    tokens.index(problem[:token].find_token_of(:next, :RPAREN, skip_blocks: true))
                  end

    # order of insertion is important, we insert right to left, so as not to muddy the indexing
    tokens.insert(right_index, PuppetLint::Lexer::Token.new(:RPAREN, ')', 0, 0))
    tokens.insert(left_index, PuppetLint::Lexer::Token.new(:NAME, TRANSLATE_FUNCTION, 0, 0))
    tokens.insert((left_index + 1), PuppetLint::Lexer::Token.new(:LPAREN, '(', 0, 0))
  end

  def function?(suspected_function)
    suspected_function.type == :FUNCTION_NAME || suspected_function.type == :NAME
  end

  def message_not_decorated?(token)
    # the next token is the openning round brace so grab the next
    suspected_i18n_function = token.next_token.next_token
    suspected_i18n_function.value != TRANSLATE_FUNCTION
  end

  def interpolation?(token)
    token.type == :DQPRE
  end

  def heredoc?(token)
    token.type == :HEREDOC_OPEN
  end
end
