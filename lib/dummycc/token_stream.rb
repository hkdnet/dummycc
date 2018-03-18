module DummyCC
  class TokenStream
    attr_accessor :cur

    def initialize
      @cur = 0
      @tokens = []
    end

    def debug
      @tokens.each do |token|
        puts token.inspect
      end
    end

    def add_token(token)
      @tokens << token
    end

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
      if @cur < 0 || @tokens.size >= @cur
        raise 'index error'
      end

      @tokens[@cur]
    end
  end
end
