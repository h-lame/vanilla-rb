require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/markdown"

describe Vanilla::Renderers::Markdown, "when rendering" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
  end
  
  it "should return the snip contents rendered via Markdown" do
    content = <<Markdown
# markdown

* totally
* [rocks](http://www.example.com)!
Markdown
    create_snip(:name => "test", :content => content)
    Vanilla::Renderers::Markdown.render('test').should == BlueCloth.new(content).to_html
  end
  
  it "should include other snips using their renderers" do
    create_snip(:name => "test", :content => <<-Markdown
# markdown

and so lets include {another_snip}    
    Markdown
    )
    create_snip(:name => "another_snip", :content => "blah", :render_as => "Bold")
    output = Vanilla::Renderers::Markdown.render("test")
    output.gsub(/\s+/, ' ').should == "<h1>markdown</h1> <p>and so lets include <b>blah</b> </p>"
  end
  
end