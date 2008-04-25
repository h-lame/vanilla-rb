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

describe Vanilla, "when checking a snip exists" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
  end
  
  it "should return true if the snip exists" do
    create_snip(:name => 'blah')
    Vanilla.snip_exists?('blah').should be_true
  end
  
  it "should return false if the snip does not exist" do
    Vanilla.snip_exists?('missing').should be_false
  end
end