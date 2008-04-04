require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/erb"

describe Vanilla::Renderers::Erb, "when rendering" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
  end

  it "should insert evaluated Erb content into the snip" do
    create_snip(:name => "test", :content => "<%= 1 + 2 %>")
    Vanilla::Renderers::Erb.render('test').should == "3"
  end
  
  it "should evaluate Erb content in the snip" do
    create_snip(:name => "test", :content => "<% if false %>monkey<% else %>donkey<% end %>")
    Vanilla::Renderers::Erb.render('test').should == "donkey"
  end
  
  it "should expose instance variables from within the renderer instance" do
    create_snip(:name => "test", :content => "<%= @snip.name %>")
    Vanilla::Renderers::Erb.render('test').should == "test"
  end
  
end