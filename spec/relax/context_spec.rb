require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Relax::Context do
  it "utilizes a custom parser for Class parsers" do
    service = CustomParserService.new
    service.test.should == 'parsed'
  end

  it "allows parameters with aliases" do
    service = ParameterAliasService.new
    service.test(:api_key => 'secret')[:stat].should == 'ok'
  end

  it "allows parameters with programmatic aliases" do
    service = ParameterAliasService.new
    service.access_as_test(:foo_bar => 'value')[:stat].should == 'ok'
  end

  it "allows blank parameters values" do
    service = BlankValuesService.new({}, :include_blank_values => true)
    service.test[:stat].should == 'ok'
  end

  it "allows custom parameter processing" do
    service = ProcessRequestService.new({:parameter => 1}, {:option => 2})
    service.test[:stat].should == 'ok'
  end

  it "allows custom parameter processing via #defaults" do
    service = DefaultProcessRequestService.new({:parameter => 1}, {:option => 2})
    service.test[:stat].should == 'ok'
  end
end
