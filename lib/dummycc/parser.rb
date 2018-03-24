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
      false
    end

    def visit_function_definition
      true
    end
  end
end
