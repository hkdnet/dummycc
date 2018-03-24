module DummyCC::AST
  class FunctionStmt
    def initialize
      @variable_decls = []
      @stmts = []
    end

    #@params variable_decl [DummyCC::AST::VariableDecl]
    def add_variable_decl(variable_decl)
      @variable_decls << variable_decl
    end

    #@params stmt [DummyCC::AST::Base]
    def add_statement(stmt)
      @stmts << stmt
    end

    def variable_decl_at(idx)
      @variable_decls[idx]
    end

    def stmt_at(idx)
      @stmts[idx]
    end
  end
end
