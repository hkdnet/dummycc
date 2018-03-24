module DummyCC::AST
  class BinaryExpr < Base
    attr_reader :op, :l, :r

    def initialize(op, l, r)
      @op = op
      @l = l
      @r = r
    end
  end
end
