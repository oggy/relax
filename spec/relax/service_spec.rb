require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Relax::Service do
  it "allows contextual defaults to be set" do
    Relax::Service.should respond_to(:defaults)
  end

  describe "#authenticate" do
    it "is callable from within a Service" do
      Relax::Service.new.should respond_to(:authenticate)
    end

    it "returns the service" do
      service = Relax::Service.new
      service.authenticate('username', 'password').should == service
    end
  end

  describe ".endpoint" do
    it "is callable from within a Service" do
      Relax::Service.should respond_to(:endpoint)
    end

    it "creates a new Endpoint" do
      Relax::Endpoint.should_receive(:new)

      class Service < Relax::Service
        endpoint "http://api.example.com/"
      end
    end
  end
end
