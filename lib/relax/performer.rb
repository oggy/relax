module Relax
  class Performer
    def initialize(method, url, values, options={})
      @method = method
      @url = url
      @values = values
      @logger = options.delete(:logger)
      @credentials = options.delete(:credentials)
      @proxy = options.delete(:proxy)
      @options = options

      parse_url_tokens
    end

    def perform
      RestClient.proxy = @proxy if @proxy

      case @method
        when :delete, :get, :head
          @logger.info "#{@method.to_s.upcase} #{url}" if @logger
          RestClient.send(@method, url)
        when :post, :put
          @logger.info "#{@method.to_s.upcase} #{url}\n#{query}" if @logger
          RestClient.send(@method, url, query)
      end
    end

    def url
      url = @url.gsub(/\:[a-z_]+/) do |name|
        @url_values[name[1..-1].to_sym]
      end

      uri = URI.parse(url)
      uri.query = query unless query.nil? || query.empty?
      uri.userinfo = @credentials.join(':') if @credentials
      uri.to_s
    end
    private :url

    def query
      @values.collect do |name, value|
        name, value = CGI.escape(name.to_s), CGI.escape(value.to_s)
        "#{name}=#{value}" if value || @options[:include_blank_values]
      end.compact.join('&').gsub(/\+/, '%20')  # not everything supports +
    end
    private :query

    def parse_url_tokens
      tokens = @url.scan(/(?:\:)([a-z_]+)/).flatten

      @url_values = tokens.inject({}) do |values, name|
        name = name.to_sym
        values[name] = @values.delete(name) if @values.key?(name)
        values
      end
    end
    private :parse_url_tokens
  end
end
