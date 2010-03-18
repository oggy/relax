class ProcessRequestService < Relax::Service
  endpoint 'http://example.com' do
    action :test do
      parameter :parameter

      process_request do |values, options|
        {'b' => values[:parameter].to_s + options[:option].to_s}
      end

      parser :response do
        attribute :stat
      end
    end
  end
end

class DefaultProcessRequestService < Relax::Service
  endpoint 'http://example.com' do
    defaults do
      process_request do |values, options|
        {'b' => values[:parameter].to_s + options[:option].to_s}
      end
    end

    action :test do
      parameter :parameter

      parser :response do
        attribute :stat
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://example.com?b=12', :body => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <response stat="ok">
  </response>
RESPONSE
