require "spec_helper"
require "vanilla/app"

describe Vanilla::App, "when detecting the snip renderer" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @app = Vanilla::App.new(nil)
  end

  it "should return the constant refered to in the render_as property of the snip" do
    snip = create_snip(:render_as => "Raw")
    @app.renderer_for(snip).should == Vanilla::Renderers::Raw
  end
  
  it "should return Vanilla::Renderers::Base if no render_as property exists" do
    snip = create_snip(:name => "blah")
    @app.renderer_for(snip).should == Vanilla::Renderers::Base
  end
  
  it "should raise an error if the specified renderer doesn't exist" do
    snip = create_snip(:render_as => "NonExistentClass")
    lambda { @app.renderer_for(snip) }.should raise_error
  end
  
  it "should load constants outside of the Vanilla::Renderers module" do
    class ::MyRenderer
    end
    
    snip = create_snip(:render_as => "MyRenderer")
    @app.renderer_for(snip).should == MyRenderer      
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

describe Vanilla::App, "when presenting as HTML" do
  before(:each) do 
    Vanilla::Test.setup_clean_environment
    create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
    create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
    create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
    create_snip :name => "other_snip", :content => "blah!"
  end
  
  it "should render the snip's content in the system template if no format or part is given" do
    # request = mock_request("/test")
    # Vanilla::App.new(request).present.should == "<tag>blah blah!</tag>"
  end
  
  # it "should render the snip's content in the system template if the HTML format is given" do
  #   request = mock_request("/test.html")
  #   Vanilla.present(params).should == "<tag>blah blah!</tag>"
  # end
  # 
  # it "should render the requested part within the main template when a part is given" do
  #   request = mock_request("/test/part")
  #   Vanilla.present(params).should == "<tag>part content</tag>"
  # end
end

__END__

describe Vanilla, "when presenting content as text" do
  before(:each) do 
    Vanilla::Test.setup_clean_environment
    create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
    create_snip :name => "other_snip", :content => "blah!"
  end
  
  it "should render the snip's content outside of the main template with its default renderer" do
    params = {:snip => 'test', :format => "text"}
    Vanilla.present(params).should == "blah blah!"
  end
  
  it "should render the snip part outside the main template when a format is given" do
    params = {:snip => 'test', :part => "part", :format => "text"}
    Vanilla.present(params).should == "part content"
  end
end

describe Vanilla, "when presenting raw content" do
  before(:each) { Vanilla::Test.setup_clean_environment }
  
  it "should render the snips contents exactly as they are" do
    create_snip(:name => 'test', :content => 'hello')
    Vanilla.present(:format => 'raw', :snip => 'test').should == 'hello'
  end
  
  it "should render the snip content exactly even if a render_as attribute exists" do
    create_snip(:name => 'test', :content => 'hello', :render_as => "Bold")
    Vanilla.present(:format => 'raw', :snip => 'test').should == 'hello'    
  end
  
  it "should render a snips part if requested" do
    create_snip(:name => 'test', :content => 'hello', :colour => 'red and black')
    Vanilla.present(:format => 'raw', :snip => 'test', :part => 'colour').should == 'red and black'
  end
end

describe Vanilla, "when asked to present a snip that doesnt exist" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
  end
  
  it "should render 404 content" do
    Vanilla.present(:snip => "missing_snip", :format => "text").should == "[Snip 'missing_snip' does not exist]"
  end
end

describe Vanilla, "when presenting nested snips with several renderers" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    create_snip :name => "test", :content => "*blah {other_snip}*", :render_as => "Markdown"
    create_snip :name => "other_snip", :content => "blah!", :render_as => "Bold"
  end
  
  it "should use the renderer specified by each snip" do
    Vanilla.present(:snip => "test", :format => "text").should == "<p><em>blah <b>blah!</b></em></p>"
  end
end

describe Vanilla, "when asked to present in an unknown format" do
  it "should return an error message" do
    Vanilla.present(:snip => "test", :format => "hairy").should == "Unknown format 'hairy'"
  end
end