module DummyCC::AST
  class JumpStmt < Base
    attr_reader :expr

    def initialize(expr)
      @expr = expr
    end
  end
end

