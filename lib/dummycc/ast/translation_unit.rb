module DummyCC::AST
  class TranslationUnit
    def initialize
      @protos = []
      @functions = []
    end

    def empty?
      @protos.empty? && @functions.empty?
    end

    #@params proto [DummyCC::AST::Prototype]
    def add_proto(proto)
      @protos << proto
    end

    #@params func [DummyCC::AST::Function]
    def add_func(func)
      @functions << func
    end

    def proto_at(idx)
      @protos[idx]
    end

    def func_at(idx)
      @functions[idx]
    end
  end
end
