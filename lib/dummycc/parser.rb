module DummyCC
  class Parser
    # @params tokens [DummyCC::TokenStream]
    def initialize(tokens)
      @tokens = tokens
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
        tu.add_proto(proto)
        return
      end
      func_def = visit_function_definition
      if func_def
        tu.add_func(func_def)
        return
      end
      raise 'No Functions...?'
    end

    def visit_function_declaration
      bkup = @tokens.cur
      proto = visit_prototype
      return nil unless proto

      unless @tokens.token.str == ';'
        # 関数定義だったので元に戻して visit_function_definition に任せる
        @tokens.cur = bkup
        return nil
      end
      # TODO: 再定義チェック
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
      return nil unless @tokens.token_str == '('
      @tokens.next

      is_first_param = true
      params = []
      loop do
        if !is_first_param && @tokens.token_type == :symbol && @tokens.token_str == ','
          @tokens.next
        end

        break unless @tokens.token_type == :int
        @tokens.next

        break unless @tokens.token_type == :identifier
        # TODO: 仮引数名重複チェック
        params << @tokens.token_str
        @tokens.next

        if @tokens.token_str == ')'
          @tokens.next
          return DummyCC::AST::Prototype.new(name, params)
        end
      end
      @tokens.cur = bkup
      nil
    end

    def visit_function_definition
      bkup = @tokens.cur
      proto = visit_prototype
      return nil unless proto

      # TODO: 再定義チェック
      visit_function_statement(proto)
    end

    def visit_function_statement
    end
  end
end
