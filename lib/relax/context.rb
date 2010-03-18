module Relax
  class Context
    attr_reader :parameters
    attr_reader :request_processors

    def initialize(parameters=[]) # :nodoc:
      @parameters = parameters
      @request_processors = []
    end

    def initialize_copy(other)
      @parameters = other.parameters.collect { |parameter| parameter.clone }
      @request_processors = other.request_processors.dup
    end

    def evaluate(&block) # :nodoc:
      instance_eval(&block)
    end

    def parameter(name, options={})
      unless @parameters.find { |parameter| parameter.named?(name) }
        @parameters << Parameter.new(name, options)
      else
        raise ArgumentError.new("Duplicate parameter '#{name}'.")
      end
    end

    def process_request(&block)
      @request_processors << block
    end

    def set(name, value)
      if parameter = @parameters.find { |parameter| parameter.named?(name) }
        parameter.value = value
      end
    end

    def parser(root, options={}, &block) # :nodoc:
      @parser ||= begin
        if root.kind_of?(Class)
          root.new(options, &block)
        else
          Relief::Parser.new(root, options, &block)
        end
      end
    end

    def parse(response) # :nodoc:
      @parser.parse(response)
    end
  end
end
