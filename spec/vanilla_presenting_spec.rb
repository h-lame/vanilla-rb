require "spec_helper"
require "vanilla"

describe Vanilla, "when presenting as HTML" do
  before(:each) do 
    Vanilla::Test.setup_clean_environment
    create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
    create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
    create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
    create_snip :name => "other_snip", :content => "blah!"
  end
  
  it "should render the snip's content in the system template if no format or part is given" do
    params = {:snip => 'test'}
    Vanilla.present(params).should == "<tag>blah blah!</tag>"
  end
  
  it "should render the snip's content in the system template if the HTML format is given" do
    params = {:snip => 'test', :format => "html"}
    Vanilla.present(params).should == "<tag>blah blah!</tag>"
  end
  
  it "should render the requested part within the main template when a part is given" do
    params = {:snip => 'test', :part => 'part'}
    Vanilla.present(params).should == "<tag>part content</tag>"
  end
end

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