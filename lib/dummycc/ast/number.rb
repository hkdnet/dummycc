module DummyCC::AST
  class Number < Base
    attr_reader :val

    def initialize(val)
      @val = val
    end
  end
end
