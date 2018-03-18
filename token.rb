class Token
  attr_reader :token, :str, :num, :lineno

  def initialize(type, str, num, lineno)
    @type = type
    @str = str
    @lineno = lineno
    if type == :digit
      @num = num.to_i
    else
      @num = 0x7fffffff
    end
  end
end
