require 'vanilla/rack_app'

use Rack::Static, :urls => ["/public"], :root => "vanilla"
run Vanilla::RackApp.new