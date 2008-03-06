#!/usr/bin/env ruby

require 'rubygems'

# i haven't updgraded rubygems here yet.
unless Kernel.respond_to?(:gem)
  def gem(*args)
    require_gem(*args)
  end
end

gem 'rack'
require 'rack'

require 'vanilla/rack_app'

# How to get this working?
# Rack::Static, :urls => ["/public"], :root => "vanilla"
Rack::Handler::CGI.run Vanilla::RackApp.new