module DummyCC::AST
  class Prototype
    attr_reader :name

    #@params name [String]
    #@params params [Array<String>]
    def initialize(name, params)
      @name = name
      @params = params
    end

    #@rerturn [String]
    def param_name_at(idx)
      @params[idx]
    end

    def params_size
      @params.size
    end
  end
end
