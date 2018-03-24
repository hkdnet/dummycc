module DummyCC::AST
  DECL_TYPES = %i(param local).freeze
  private_constant :DECL_TYPES

  class Base
    def type
      @type ||= self.class.name.downcase.to_sym
    end
  end
end
