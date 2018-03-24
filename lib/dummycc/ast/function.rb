module DummyCC::AST
  class Function
    attr_reader :proto, :body

    #@params proto [DummyCC::AST::Prototype]
    #@params body [DummyCC::AST::FunctionStmt]
    def initialize(proto, body)
      @proto = proto
      @body = body
    end

    def name
      @proto.name
    end
  end
end
