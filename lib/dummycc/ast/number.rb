module DummyCC::AST
  class Number < Base
    attr_reader :val

    def initialize(val)
      @val = val
    end

    def ==(other)
      unless %i(type val).all? { |e| other.respond_to?(e) }
        return false
      end
      type == other.type && val == other.val
    end
  end
end
