module DummyCC
  class BaseError < StandardError
  end
  class SyntaxError < BaseError
  end
  class IndexError < BaseError
  end
  class UnknownTypeError < BaseError
  end
  class UnknownDeclTypeError < BaseError
  end
end
