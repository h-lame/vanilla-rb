require "spec_helper"
require "vanilla/request"

describe Vanilla::Request, "when requesting urls" do
  before(:each) { @request = mock_request("/snip") }
  
  it "should use the first segement as the snip name" do
    @request.snip_name.should == "snip"
  end
  
  it "should try to load the snip based on the snip name" do
    Vanilla.should_receive(:snip).with('snip').and_return(:snip)
    @request.snip.should == :snip
  end
  
  it "should have no part if the url contains only a single segment" do
    @request.part.should == nil    
  end
  
  it "should have a default format of html" do
    @request.format.should == 'html'
  end
  
  it "should determine the request method" do
    @request.method.should == 'get'
  end
end

describe Vanilla::Request, "when requesting a snip part" do
  before(:each) { @request = mock_request("/snip/part") }
  
  it "should use the first segment as the snip, and the second segment as the part" do
    @request.snip_name.should == "snip"
    @request.part.should == "part"
  end
  
  it "should have a default format of html" do
    @request.format.should == "html"
  end
end

describe Vanilla::Request, "when requesting a snip with a format" do
  before(:each) { @request = mock_request("/snip.raw") }
  
  it "should use the extension as the format" do
    @request.format.should == "raw"
  end
  
  it "should retain the filename part of the path as the snip" do
    @request.snip_name.should == "snip"
  end
end

describe Vanilla::Request, "when requesting a snip part with a format" do
  before(:each) { @request = mock_request("/snip/part.raw") }
  
  it "should use the extension as the format" do
    @request.format.should == "raw"
  end
  
  it "should retain the first segment of the path as the snip" do
    @request.snip_name.should == "snip"
  end
  
  it "should use the filename part of the second segment as the snip part" do
    @request.part.should == "part"
  end
end

describe Vanilla::Request, "when requested with a _method paramter" do
  it "should return the method using the parameter" do
    mock_request("/snip?_method=put").method.should == 'put'
  end
end