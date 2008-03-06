#!/usr/bin/env ruby

require 'vanilla/rack_app'

# How to get this working?
# Rack::Static, :urls => ["/public"], :root => "vanilla"
Rack::Handler::CGI.run Vanilla::RackApp.new