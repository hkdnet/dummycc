module DummyCC
  class FunctionSignature
    attr_reader :name, :ret_type, :proto_types

    def initialize(name, ret_type, proto_types)
      @name = name
      @ret_type = ret_type
      @proto_types = proto_types
    end

    def ==(other)
      %i(name ret_type proto_types).all? { |e| other.respond_to?(e) }

      name == other.name && ret_type == other.ret_type && proto_types == other.proto_types
    end
  end
end
