#!/home/bin/env ruby

# In case we haven't upgraded Rubygems yet
unless Kernel.respond_to?(:gem)
  def gem(*args)
    require_gem(*args)
  end
end

def run(*args)
  # fake out the call in vanilla/vanilla.ru
end

require 'rubygems'
gem 'rack'
require 'rack'

load 'vanilla/rack_app'

Rack::Handler::FastCGI.run Vanilla::App, {:Host => '0.0.0.0'}
