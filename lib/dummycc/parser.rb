module DummyCC
  class Parser
    # @params tokens [DummyCC::TokenStream]
    def initialize(tokens)
      @tokens = tokens
      @signatures = {}
    end

    def exec
      tu = DummyCC::AST::TranslationUnit.new
      visit_translation_unit(tu)
      tu
    end

    private

    def visit_translation_unit(tu)
      loop do
        visit_external_declaration(tu)
        break if @tokens.token_type == :eof
      end
      tu
    end

    def visit_external_declaration(tu)
      proto = visit_function_declaration
      if proto
        @signatures[proto.name] = proto.to_signature
        tu.add_proto(proto)
        return
      end
      func_def = visit_function_definition
      if func_def
        proto = func_def.proto
        @signatures[proto.name] = proto.to_signature
        tu.add_func(func_def)
        return
      end
      raise 'No Functions...?'
    end

    def visit_function_declaration
      bkup = @tokens.cur
      proto = visit_prototype
      return nil unless proto

      unless @tokens.semicolon?
        # 関数定義だったので元に戻して visit_function_definition に任せる
        @tokens.cur = bkup
        return nil
      end

      # 再定義チェック
      if @signatures.key?(proto.name)
        if proto.to_signature == @signatures[proto.name]
          # 完全一致なのでwarningだけ
          warn("Duplicated function declaration for #{proto.name}")
        else
          raise DummyCC::ConflictingTypesError, "for function #{proto.name}"
        end
      end

      @tokens.next
      proto
    end

    # PROTOTYPE := TYPE IDENTIFIER ( PARAMETER[, PARAMETER] )
    # PARAMETER := TYPE IDENTIFIER
    def visit_prototype
      bkup = @tokens.cur

      return nil unless @tokens.token_type == :int
      @tokens.next
      return nil unless @tokens.token_type == :identifier
      name = @tokens.token_str
      @tokens.next
      return nil unless @tokens.l_paren?
      @tokens.next

      is_first_param = true
      params = []
      loop do
        if @tokens.r_paren?
          @tokens.next
          return DummyCC::AST::Prototype.new(name, params)
        end

        if !is_first_param && @tokens.comma?
          @tokens.next
        end

        break unless @tokens.token_type == :int
        @tokens.next

        break unless @tokens.token_type == :identifier
        # TODO: 仮引数名重複チェック
        params << @tokens.token_str
        @tokens.next
        is_first_param = false
      end
      @tokens.cur = bkup
      nil
    end

    # @return [DummyCC::AST::Function]
    def visit_function_definition
      proto = visit_prototype
      return nil unless proto

      # TODO: 再定義チェック
      body = visit_function_statement(proto)
      DummyCC::AST::Function.new(proto, body)
    end

    # FUNCITON_STMT := { VARIABLE_DECL_LIST [VARIABLE_DECL_LIST] STATEMENT_LIST }
    # VARIABLE_DECL_LIST := VARIABLE_DECL [VARIABLE_DECL]
    # VARIABLE_DECL := int IDENTIFIER;
    # STATEMENT_LIST := STATEMENT [STATEMENT]
    # @return [DummyCC::AST::FunctionStmt]
    def visit_function_statement(proto)
      bkup = @tokens.cur
      return nil unless @tokens.l_brace?
      @tokens.next
      body = DummyCC::AST::FunctionStmt.new
      proto.each do |param_name|
        decl = DummyCC::AST::VariableDecl.new(param_name, :param)
        body.add_variable_decl(decl)
      end

      loop do
        decl = visit_variable_declaration
        if decl
          body.add_variable_decl(decl)
          next
        end

        stmt = visit_statement
        if stmt
          body.add_statement(stmt)
          next
        end

        if @tokens.r_brace?
          break
        end
        if @tokens.token_type == :eof
          @tokens.cur = bkup
          return nil
        end
      end
      @tokens.next
      body
    end

    def visit_variable_declaration
      bkup = @tokens.cur

      unless @tokens.token_type == :int
        @tokens.cur = bkup
        return nil
      end
      @tokens.next
      unless @tokens.token_type == :identifier
        @tokens.cur = bkup
        return nil
      end
      name = @tokens.token_str
      @tokens.next
      unless @tokens.semicolon?
        @tokens.cur = bkup
        return nil
      end
      @tokens.next
      DummyCC::AST::VariableDecl.new(name, :local)
    end

    def visit_statement
      return nil if @tokens.r_brace?
      stmt = visit_expression_stmt
      return stmt if stmt
      stmt = visit_jump_stmt
      return stmt if stmt
      @tokens.next
    end

    def visit_expression_stmt
      bkup = @tokens.cur
      if @tokens.semicolon?
        @tokens.next
        return DummyCC::AST::NullExpr.new
      end
      expr = visit_assignment_expr
      if expr
        unless @tokens.semicolon?
          @tokens.cur = bkup
          return nil
        end
        @tokens.next
        return expr
      end
      nil
    end

    def visit_jump_stmt
      return nil unless @tokens.token_type == :return
      bkup = @tokens.cur
      @tokens.next
      expr = visit_assignment_expr
      unless expr
        @tokens.cur = bkup
        return nil
      end

      unless @tokens.semicolon?
        @tokens.cur = bkup
        return nil
      end
      @tokens.next
      DummyCC::AST::JumpStmt.new(expr)
    end

    # ASSIGNMENT_EXPR := IDENTIFIER = ADDITIVE_EXPR | ADDITIVE_EXPR
    def visit_assignment_expr
      bkup = @tokens.cur
      if @tokens.token_type == :identifier
        l = DummyCC::AST::Variable.new(@tokens.token_str)
        @tokens.next
        if @tokens.symbol_eq?
          @tokens.next
          r = visit_additive_expr(nil)
          return DummyCC::AST::BinaryExpr.new("=", l, r) if r
        end
        @tokens.cur = bkup
      end

      add_expr = visit_additive_expr(nil)
      return add_expr if add_expr
      nil
    end

    # @param lhs [DummyCC::AST::Base]
    def visit_additive_expr(lhs)
      bkup = @tokens.cur

      if lhs.nil?
        lhs = visit_multiplicative_expr(nil)
        return nil if lhs.nil?
      end
      if @tokens.plus?
        @tokens.next
        rhs = visit_multiplicative_expr(nil)
        unless rhs
          @tokens.cur = bkup
          return nil
        end
        return visit_additive_expr(DummyCC::AST::BinaryExpr.new('+', lhs, rhs))
      elsif @tokens.minus?
        @tokens.next
        rhs = visit_multiplicative_expr(nil)
        unless rhs
          @tokens.cur = bkup
          return nil
        end
        return visit_additive_expr(DummyCC::AST::BinaryExpr.new('-', lhs, rhs))
      end
      lhs
    end

    def visit_multiplicative_expr(lhs)
      bkup = @tokens.cur

      if lhs.nil?
        lhs = visit_postfix_expr
        return nil if lhs.nil?
      end

      if @tokens.asterisk?
        @tokens.next

        rhs = visit_postfix_expr
        unless rhs
          @tokens.cur = bkup
          return nil
        end
        return visit_multiplicative_expr(DummyCC::AST::BinaryExpr.new('*', lhs, rhs))
      elsif @tokens.slash?
        @tokens.next

        rhs = visit_postfix_expr
        unless rhs
          @tokens.cur = bkup
          return nil
        end
        return visit_multiplicative_expr(DummyCC::AST::BinaryExpr.new('/', lhs, rhs))
      end
      lhs
    end

    # POSTFIX_EXPR := PRIMARY_EXPR | IDENTIFIER ( [ASSIGNMENT_EXPR [, ASSIGNMENT_EXPR]] )
    def visit_postfix_expr
      bkup = @tokens.cur

      expr = visit_primary_expr
      return expr if expr

      unless @tokens.token_type == :identifier
        return nil
      end

      callee = @tokens.cur_str
      @tokens.next
      unless @tokens.l_paren?
        @tokens.cur = bkup
        return nil
      end
      @tokens.next
      args = []
      is_first_arg = true
      loop do
        if !is_first_arg
          unless @tokens.comma?
            @tokens.cur = bkup
            return nil
          end
          @tokens.next
        end
        is_first_arg = false
        expr = visit_assignment_expr
        if expr
          args << expr
        else
          break
        end
      end

      unless @tokens.r_paren?
        @tokens.cur = bkup
        return nil
      end
      @tokens.next

      DummyCC::AST::CallExpr.new(callee, args)
    end

    # PRIMARY_EXPR := IDENTIFIER | INTEGER | ( ADDITIVE_EXPR )
    def visit_primary_expr
      bkup = @tokens.cur

      if @tokens.token_type == :identifier
        var = DummyCC::AST::Variable.new(@tokens.token_str)
        @tokens.next
        return var
      elsif @tokens.token_type == :digit
        num = DummyCC::AST::Number.new(@tokens.token_num)
        @tokens.next
        return num
      elsif @tokens.minus?
        @tokens.next
        if @tokens.token_type == :digit
          num = DummyCC::AST::Number.new(-@tokens.toen_num)
          @tokens.next
          return num
        end
        @tokens.cur = bkup
      elsif @tokens.l_paren?
        @tokens.next
        expr = visit_additive_expr(nil)
        if expr && @tokens.r_paren?
          @tokens.next
          return expr
        end
        @tokens.cur = bkup
      end

      nil
    end
  end
end
