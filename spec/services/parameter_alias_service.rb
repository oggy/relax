class ParameterAliasService < Relax::Service
  endpoint 'http://example.com/' do
    action :test do
      parameter :APIKey, :as => :api_key, :required => true

      parser :response do
        attribute :stat
      end
    end

    action :access_as_test do
      parameter :FooBar

      access_as do |camel|
        camel.gsub(/([a-z])([A-Z])/){"#{$1}_#{$2.downcase}"}.sub(/\A[A-Z]/){|s| s.downcase}
      end

      parser :response do
        attribute :stat
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://example.com/?APIKey=secret', :body => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <response stat="ok">
  </response>
RESPONSE

FakeWeb.register_uri(:get, 'http://example.com/?FooBar=value', :body => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <response stat="ok">
  </response>
RESPONSE
