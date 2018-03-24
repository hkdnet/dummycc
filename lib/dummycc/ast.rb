module DummyCC::AST
  DECL_TYPES = %i(param local).freeze
  private_constant :DECL_TYPES

  class Base
    def type
      @type ||= self.class.name.downcase.to_sym
    end
  end

  class VariableDecl < Base
    attr_reader :name, :decl_type

    def initialize(name, decl_type)
      unless DECL_TYPES.include?(decl_type)
        raise DummyCC::UnknownDeclTypeError, "No such decl_type: #{decl_type}"
      end
      @name = name
      @decl_type = decl_type
    end
  end

  class BinaryExpr < Base
    attr_reader :op, :l, :r

    def initialize(op, l, r)
      @op = op
      @l = l
      @r = r
    end
  end

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

  class JumpStmt < Base
    attr_reader :expr

    def initialize(expr)
      @expr = expr
    end
  end
end
