require "spec_helper"
require "vanilla"

describe Vanilla, "when presenting raw content" do
  before(:each) { Vanilla::Test.setup_clean_environment }
  
  it "should render the snips contents" do
    create_snip(:name => 'test', :content => 'hello')
    Vanilla.present(:format => 'raw', :snip => 'test').should == 'hello'
  end
  
  it "should render a snips part if requested" do
    create_snip(:name => 'test', :content => 'hello', :colour => 'red and black')
    Vanilla.present(:format => 'raw', :snip => 'test', :part => 'colour').should == 'red and black'
  end
end

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
  
  it "should be able to properly get namespaced constants" do
    pending("this needs a loop to work") do
      class ::MyRenderer
        class Base
        end
      end
      
      snip = create_snip(:render_as => "MyRenderer::Base")
      Vanilla.renderer_for(snip).should == MyRenderer::Base      
    end
  end
end