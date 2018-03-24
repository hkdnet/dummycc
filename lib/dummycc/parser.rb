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
    end
  end
end
