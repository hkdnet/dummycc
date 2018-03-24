module DummyCC::AST
  class CallExpr < Base
    attr_reader :callee

    def initialize(callee, args)
      @callee = callee
      @args = args
    end

    def arg_at(idx)
      if idx < 0 || idx >= @args.size
        raise DummyCC::IndexError
      end
      @args[idx]
    end
  end
end
