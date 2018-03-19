module DummyCC
  class Token
    class UnknownTypeError < StandardError; end
    TYPES = %i(int return identifier digit symbol eof).freeze
    private_constant :TYPES

    attr_reader :type, :str, :num, :lineno

    def initialize(str, type, lineno)
      unless TYPES.include?(type)
        raise UnknownTypeError, type
      end

      @str = str
      @type = type
      @lineno = lineno
      if type == :digit
        @num = str.to_i
      end
    end

    def ==(other)
      other.is_a?(DummyCC::Token) &&
        type == other.type &&
        str == other.str &&
        num == other.num &&
        lineno == other.lineno
    end

    def inspect
      text = "#{type}: #{str}"
      if @num
        text << " as #{num}"
      end
      text << " at #{lineno}"
      text
    end
  end
end
