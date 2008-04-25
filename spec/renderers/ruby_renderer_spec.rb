require File.join(File.dirname(__FILE__), *%w[.. spec_helper])

class TestDyna < Dynasnip
  def handle(*args)
    'handle called'
  end
end


describe Vanilla::Renderers::Ruby, "when rendering normally" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @app = Vanilla::App.new(mock_request("/test_dyna"))
    @renderer = Vanilla::Renderers::Ruby.new(@app)
    @test_dyna = TestDyna.persist!
  end
  
  it "should render the result of the handle method" do
    test_dyna = TestDyna.persist!
    @renderer.render(@test_dyna).should == 'handle called'
  end
end

class RestishDyna < Dynasnip
  def get(*args)
    'get called'
  end
  def post(*args)
    'post called'
  end  
end

describe Vanilla::Renderers::Ruby, "when responding restfully" do
  before(:each) do
    Vanilla::Test.setup_clean_environment
    @request = mock_request("/test_dyna")
    @app = Vanilla::App.new(@request)
    @renderer = Vanilla::Renderers::Ruby.new(@app)
    @dyna = RestishDyna.persist!
  end
  
  it "should render the result of the get method on GET requests" do
    @request.should_receive(:method).and_return(:get)
    @renderer.render(@dyna).should == 'get called'
  end
  
  it "should render the result of the post method on POST requests" do
    @request.should_receive(:method).and_return(:post)
    @renderer.render(@dyna).should == 'post called'
  end
  
end