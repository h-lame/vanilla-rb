require "spec_helper"
require "vanilla"

describe Vanilla, "when presenting" do
  before(:each) do 
    Vanilla::Test.setup_clean_environment
    create_snip :name => "test", :content => "blah {other_snip}"
    create_snip :name => "other_snip", :content => "blah!"
  end
  
  it "should render the system template if no format is given" do
    create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
    create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
    params = {:snip => 'test'}
    Vanilla.present(params).should == "<tag>blah blah!</tag>"
  end
  
  it "should render the system template if the HTML format is given" do
    create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
    create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
    params = {:snip => 'test', :format => "html"}
    Vanilla.present(params)    
    Vanilla.present(params).should == "<tag>blah blah!</tag>"
  end
  
  it "should render the snip outside of the main template with its default renderer if the text format is given" do
    params = {:snip => 'test', :format => "text"}
    Vanilla.present(params).should == "blah blah!"
  end
  
  it "should render the raw contents of the snip if the raw format is given" do
    params = {:snip => 'test', :format => "raw"}
    Vanilla.present(params).should == "blah {other_snip}"
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