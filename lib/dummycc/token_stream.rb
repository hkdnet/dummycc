module DummyCC
  class TokenStream
    attr_accessor :cur

    def initialize
      @cur = 0
      @tokens = []
    end

    def add_token(token)
      @tokens << token
    end
    alias << add_token

    def next(diff = 1)
      @cur += diff
    end

    def prev(diff = 1)
      @cur -= diff
    end

    def token_type
      token.type
    end

    def token_str
      token.str
    end

    def token_num
      token.num
    end

    def token
      if @cur < 0 || @cur >= @tokens.size
        raise DummyCC::IndexError, "size: #{@tokens.size}, cur: #{@cur}"
      end

      @tokens[@cur]
    end
  end
end
