require "spec_helper"
require "vanilla"

describe Vanilla, "when loading a snip" do
  
  it "should delegate to Soup" do
    snip = :snip
    Soup.should_receive(:[]).with('name').and_return(snip)
    Vanilla.snip('name').should == :snip
  end
  
  it "should raise an exception if the snip cannot be found" do
    lambda { Vanilla.snip('missing') }.should raise_error(Vanilla::MissingSnipException)
  end
end