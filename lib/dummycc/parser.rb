module DummyCC
  class Parser
    def initialize(text)
      @text = text
      @comment = false
    end

    def parse
      tokens = TokenStream.new
      token_str = ''
      lineno = 0
      colno = 0
      while lineno < lines.size
        lineno += 1
        colno = 0
        line = lines[lineno - 1]

        while colno < line.size
          colno += 1
          if comment?
            if comment_end?(lineno, colno)
              @comment = false
              colno += 1
            end
            next
          end

          if space?(lineno, colno)
            next
          elsif alpha?(lineno, colno)
            # なるだけ読む
            while alphanum?(lineno, colno)
              token_str += char_at(lineno, colno)
              break if eol?(lineno, colno)
              colno += 1
            end

            # alphanum? でないときは読みすぎているので戻す
            colno -= 1 unless alphanum?(lineno, colno)

            if token_str == 'int' # 型宣言のとき
              tokens.add_token(Token.new(token_str, :int, lineno))
            elsif token_str == 'return'
              tokens.add_token(Token.new(token_str, :return, lineno))
            else
              tokens.add_token(Token.new(token_str, :identifier, lineno))
            end
          elsif digit?(lineno, colno)
            if char_at(lineno, colno) == '0'
              token_str += char_at(lineno, colno)
              tokens.add_token(Token.new(token_str, :digit, lineno))
            else
              while digit?(lineno, colno)
                token_str += char_at(lineno, colno)
                break if eol?(lineno, colno)
                colno += 1
              end

              # digit? でないときは読みすぎているので戻す
              colno -= 1 unless digit?(lineno, colno)

              tokens.add_token(Token.new(token_str, :digit, lineno))
            end
          elsif char_at(lineno, colno) == '/'
            if char_at(lineno, colno + 1) == '/'
              # この行読み飛ばし。
              # TODO: これあってるか？
              break
            elsif char_at(lineno, colno + 1) == '*'
              # TODO: これあってるか？
              colno += 1
              @comment = true
              next
            else # divider
              token_str += char_at(lineno, colno)
              tokens.add_token(Token.new(token_str, :symbol, lineno))
            end
          else
            # その他記号
            if %w[* + - = ; , ( ) { }].include?(char_at(lineno, colno))
              token_str += char_at(lineno, colno)
              tokens.add_token(Token.new(token_str, :symbol, lineno))
            else
              raise "Unclear token: #{char_at(lineno, colno)} at line: #{lineno}, col: #{colno}"
            end
          end

          token_str = ''
        end
      end
      tokens.add_token(Token.new('', :eof, lines.size))
      tokens
    end

    private

    def alpha?(lineno, colno)
      /[a-zA-Z]/.match?(char_at(lineno, colno))
    end

    def digit?(lineno, colno)
      /[0-9]/.match?(char_at(lineno, colno))
    end

    def alphanum?(lineno, colno)
      alpha?(lineno, colno) || digit?(lineno, colno)
    end

    def eol?(lineno, colno)
      line = lines[lineno - 1]
      line.size == colno
    end

    def space?(lineno, colno)
      [' ',  "\n", "\t"].include? char_at(lineno, colno)
    end

    def comment_end?(lineno, colno)
      char_at(lineno, colno) == '*' && char_at(lineno, colno + 1) == '/'
    end

    def char_at(lineno, colno)
      lineno -= 1
      colno -= 1
      lines[lineno][colno]
    end

    def comment?
      @comment
    end

    def lines
      @lines = @text.lines
    end
  end
end
