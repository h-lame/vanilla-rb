require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/erb"

describe Vanilla::Renderers::Erb, "when rendering" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @renderer = Vanilla::Renderers::Erb.new(Vanilla::App.new(nil))
  end

  it "should insert evaluated Erb content into the snip" do
    s = create_snip(:name => "test", :content => "<%= 1 + 2 %>")
    @renderer.render(s).should == "3"
  end
  
  it "should evaluate Erb content in the snip" do
    s = create_snip(:name => "test", :content => "<% if false %>monkey<% else %>donkey<% end %>")
    @renderer.render(s).should == "donkey"
  end
  
  it "should expose instance variables from within the renderer instance" do
    s = create_snip(:name => "test", :content => "<%= @snip.name %>")
    @renderer.render(s).should == "test"
  end
  
end