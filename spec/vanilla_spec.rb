require "spec_helper"
require "vanilla"

describe Vanilla, "when detecting the snip renderer" do
  before(:each) { Vanilla::Test.setup_clean_environment }

  it "should return the constant refered to in the render_as property of the snip" do
    snip = create_snip(:render_as => "Raw")
    Vanilla.renderer_for(snip).should == Vanilla::Renderers::Raw
  end
  
  it "should return Vanilla::Renderers::Base if no render_as property exists" do
    snip = create_snip(:name => "blah")
    Vanilla.renderer_for(snip).should == Vanilla::Renderers::Base
  end
  
  it "should raise an error if the specified renderer doesn't exist" do
    snip = create_snip(:render_as => "NonExistentClass")
    lambda { Vanilla.renderer_for(snip) }.should raise_error
  end
  
  it "should load constants outside of the Vanilla::Renderers module" do
    class ::MyRenderer
    end
    
    snip = create_snip(:render_as => "MyRenderer")
    Vanilla.renderer_for(snip).should == MyRenderer      
  end
  
  # it "should be able to properly get namespaced constants" do
  #   pending("this needs string splitting and a loop to work; it's not really needed at the moment") do
  #     class ::MyRenderer
  #       class Base
  #       end
  #     end
  #     
  #     snip = create_snip(:render_as => "MyRenderer::Base")
  #     Vanilla.renderer_for(snip).should == MyRenderer::Base      
  #   end
  # end
end