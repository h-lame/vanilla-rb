require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/markdown"

describe Vanilla::Renderers::Markdown, "when rendering" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @renderer = Vanilla::Renderers::Markdown.new(Vanilla::App.new(nil))
  end
  
  it "should return the snip contents rendered via Markdown" do
    content = <<Markdown
# markdown

* totally
* [rocks](http://www.example.com)!
Markdown
    snip = create_snip(:name => "test", :content => content)
    @renderer.render(snip).should == BlueCloth.new(content).to_html
  end
  
  it "should include other snips using their renderers" do
    snip = create_snip(:name => "test", :content => <<-Markdown
# markdown

and so lets include {another_snip}    
    Markdown
    )
    create_snip(:name => "another_snip", :content => "blah", :render_as => "Bold")
    output = @renderer.render(snip)
    output.gsub(/\s+/, ' ').should == "<h1>markdown</h1> <p>and so lets include <b>blah</b> </p>"
  end
  
end