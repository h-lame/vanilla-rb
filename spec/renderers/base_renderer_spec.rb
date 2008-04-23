require File.join(File.dirname(__FILE__), *%w[.. spec_helper])

describe Vanilla::Renderers::Base, "in general" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @snip = create_snip(:name => "test", :content => "content content", :part => "part content")
  end

  it "should render the contents part of the snip as it is" do
    Vanilla::Renderers::Base.render(@snip).should == "content content"
  end
  
  it "should render the specified part of the snip" do
    Vanilla::Renderers::Base.render(@snip.part).should == "part content"
  end
  
  it "should include the contents of a referenced snip" do
    snip_with_inclusions = create_snip(:name => "snip_with_inclusions", :content => "loading {another_snip}")
    create_snip(:name => "another_snip", :content => "blah blah")
    Vanilla::Renderers::Base.render(snip_with_inclusions).should == "loading blah blah"
  end
  
  it "should perform snip inclusion when rendering a part" do
    snip_with_inclusions = create_snip(:name => "snip_with_inclusions", :content => "", :part => "loading {another_snip}")
    create_snip(:name => "another_snip", :content => "blah blah")
    Vanilla::Renderers::Base.render(snip_with_inclusions.part).should == "loading blah blah"
  end
end