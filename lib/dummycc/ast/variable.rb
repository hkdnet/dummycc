module DummyCC::AST
  class Variable < Base
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end
