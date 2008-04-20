require 'rubygems'

# In case we haven't upgraded Rubygems yet
unless Kernel.respond_to?(:gem)
  def gem(*args)
    require_gem(*args)
  end
end

gem 'soup', '>= 0.1.4'
require 'soup'

module Vanilla

end

def dynasnip(*args)
  # do nothing
end
def snip(*args)
  # do nothing
end

# Load all the other renderer subclasses
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'renderers', '*.rb')].each { |f| require f }  

# Load the routing information
require 'vanilla/routes'

# Load all the base dynasnip classes
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'dynasnips', '*.rb')].each do |dynasnip|
  require dynasnip
end