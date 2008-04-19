require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/raw"

describe Vanilla::Renderers::Raw, "when rendering" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    create_snip(:name => "test", :content => "raw content", :part => "raw part")
  end

  it "should render the contents part of the snip as it is" do
    Vanilla::Renderers::Raw.render('test').should == "raw content"
  end
  
  it "should render the specified part of the snip" do
    Vanilla::Renderers::Raw.render('test', 'part').should == "raw part"
  end
  
  it "should not perform any snip inclusion" do
    create_snip(:name => "snip_with_inclusions", :content => "loading {another_snip}")
    Vanilla::Renderers::Raw.render("snip_with_inclusions").should == "loading {another_snip}"
  end
end