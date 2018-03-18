module DummyCC
  class Token
    attr_reader :type, :str, :num, :lineno

    def initialize(str, type, lineno)
      @str = str
      @type = type
      @lineno = lineno
      if type == :digit
        @num = str.to_i
      end
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
