module DummyCC::AST
  class Variable < Base
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def ==(other)
      unless %i(name).all? { |e| other.respond_to?(e) }
        return false
      end

      name == other.name
    end
  end
end
