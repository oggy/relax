class SpacesService < Relax::Service
  endpoint 'http://example.com' do
    action :test do
      parameter :'a b'

      parser :response do
        attribute :stat
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://example.com?a%20b=c%20d', :body => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <response stat="ok">
  </response>
RESPONSE
