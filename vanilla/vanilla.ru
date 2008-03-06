require 'vanilla'
require 'vanilla/rack_app'

Soup.prepare

# TODO: get this working
use Rack::Static, :urls => ["/public"], :root => "vanilla"
run Vanilla::RackApp.new
