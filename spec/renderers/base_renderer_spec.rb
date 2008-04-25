require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require 'vanilla/renderers/base'

describe Vanilla::Renderers::Base, "in general" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    app = Vanilla::App.new(nil)
    @renderer = Vanilla::Renderers::Base.new(app)
    @snip = create_snip(:name => "test", :content => "content content", :part => "part content")
  end

  it "should render the contents part of the snip as it is" do
    @renderer.render(@snip).should == "content content"
  end
  
  it "should render the specified part of the snip" do
    @renderer.render(@snip, :part).should == "part content"
  end
  
  it "should include the contents of a referenced snip" do
    snip_with_inclusions = create_snip(:name => "snip_with_inclusions", :content => "loading {another_snip}")
    create_snip(:name => "another_snip", :content => "blah blah")
    @renderer.render(snip_with_inclusions).should == "loading blah blah"
  end
  
  it "should perform snip inclusion when rendering a part" do
    snip_with_inclusions = create_snip(:name => "snip_with_inclusions", :content => "", :part => "loading {another_snip}")
    create_snip(:name => "another_snip", :content => "blah blah")
    @renderer.render(snip_with_inclusions, :part).should == "loading blah blah"
  end
  
  it "should include other snips using their renderers" do
    snip = create_snip(:name => "test", :content => "lets include {another_snip}")
    create_snip(:name => "another_snip", :content => "blah", :render_as => "Bold")
    @renderer.render(snip).gsub(/\s+/, ' ').should == "lets include <b>blah</b>"
  end
  
  it "should call prepare before rendering" do
    snip = create_snip(:name => "test", :content => "some snip")
    @renderer.should_receive(:prepare).with(snip, :content, [])
    puts @renderer.render(snip)
  end
end

describe Vanilla::Renderers::Base, "when trying to render a missing snip" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    app = Vanilla::App.new(nil)
    @renderer = Vanilla::Renderers::Base.new(app)
    @snip = create_snip(:name => 'blah', :content => 'include a {missing_snip}')
  end

  it "should return a string describing the missing snip" do
    @renderer.render(@snip).should == "include a [snip 'missing_snip' cannot be found]"
  end
end