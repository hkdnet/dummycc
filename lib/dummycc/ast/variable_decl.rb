module DummyCC::AST
  DECL_TYPES = %i(param local).freeze
  private_constant :DECL_TYPES

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
end
