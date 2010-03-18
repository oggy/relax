module Relax
  class Parameter
    attr_reader :context, :name, :options
    attr_writer :value

    def initialize(context, name, options={})
      @context = context
      @name = name
      @options = options
    end

    def named?(name)
      name == (@options[:as] || @name)
    end

    def accessor_name
      @accessor_name ||= @options[:as] || proc_name || name
    end

    def value
      @value || @options[:default]
    end

    def required?
      @options[:required]
    end

    private

    def proc_name
      proc = @context.alias_proc and
        proc.call(name.to_s).to_sym
    end
  end
end
