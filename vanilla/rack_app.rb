require 'vanilla/app'

gem 'rack'
require 'rack'


module Vanilla
  class RackApp
    
    # Create a new Vanilla Rack Application.
    # Set the dreamhost_fix parameter to true to get the request path from the SCRIPT_URL
    # environment variable, rather than the request.path_info method.
    def initialize(dreamhost_fix=false)
      Soup.prepare
      @dreamhost_fix = dreamhost_fix
    end
    
    def request_for(env)
      Vanilla::Request.new(Rack::Request.new(env), @dreamhost_fix)
    end
    
    # The call method required by all good Rack applications
    def call(env)
      request = request_for(env)
      if request.snip_name
        Vanilla::App.new(request).present
      else
        # four_oh_four = Vanilla::App.new.present(:snip => 'system', :part => 'four_oh_four', :format => 'html')
        [404, {"Content-Type" => "text/html"}, [four_oh_four]]
      end
    end
  end
end