require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/raw"

describe Vanilla::Renderers::Raw, "when rendering" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @renderer = Vanilla::Renderers::Raw.new(Vanilla::App.new(nil))
    @snip = create_snip(:name => "test", :content => "raw content", :part => "raw part")
  end

  it "should render the contents part of the snip as it is" do
    @renderer.render(@snip).should == "raw content"
  end
  
  it "should render the specified part of the snip" do
    @renderer.render(@snip, :part).should == "raw part"
  end
  
  it "should not perform any snip inclusion" do
    s = create_snip(:name => "snip_with_inclusions", :content => "loading {another_snip}")
    @renderer.render(s).should == "loading {another_snip}"
  end
end