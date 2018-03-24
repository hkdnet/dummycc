module DummyCC::AST
  class Base
    def type
      @type ||= self.class.name.downcase.to_sym
    end
  end
end
