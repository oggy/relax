module Relax
  class Instance # :nodoc:
    def initialize(options, *args)
      @options = options

      @values = args.inject({}) do |values, arg|
        arg.is_a?(Hash) ? values.merge(arg) : values
      end
    end

    def values(context)
      context.parameters.inject({}) do |values, parameter|
        name = parameter.accessor_name

        if (value = @values[name] || parameter.value) || @options[:include_blank_values]
          values[parameter.name] = value
        elsif parameter.required?
          raise ArgumentError.new("Missing value for '#{name}'.")
        end

        values
      end
    end
  end
end
