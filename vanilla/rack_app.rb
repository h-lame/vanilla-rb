require 'vanilla'

gem 'rack'
require 'rack'


module Vanilla
  class RackApp
    # Create a request with indifferent-hash-style access to the params
    class Request < Rack::Request
      def params
        # Don't you just love how terse functional programming tends to look like maths?
        @indifferent_params ||= super.inject({}) { |p, (k,v)| p[k.to_sym] = v; p }
      end
    end
    
    # Create a new Vanilla Rack Application.
    # Set the dreamhost_fix parameter to true to get the request path from the SCRIPT_URL
    # environment variable, rather than the request.path_info method.
    def initialize(dreamhost_fix=false)
      Soup.prepare
      @dreamhost_fix = dreamhost_fix
    end
    
    # The call method required by all good Rack applications
    def call(env)
      request = Request.new(env)      
      snip, part, format = request_uri_parts(request)
      if snip
        params = request.params.merge(:snip => snip, :part => part, 
                                      :format => format, :method => request.request_method.downcase)
        [200, {"Content-Type" => "text/html"}, [Vanilla.present(params)]]
      else
        four_oh_four = Vanilla.present(:snip => 'system', :part => 'four_oh_four', :format => 'html')
        [404, {"Content-Type" => "text/html"}, [four_oh_four]]
      end
    end
    
    private
    
    # TODO: this is ugly, but cgi on dreamhost doesn't give anything in path_info
    def uri_path(request)
      @dreamhost_fix ? env["SCRIPT_URL"] : request.path_info
    end
    
    URL_ROOT          = /\A\/\Z/                                  # i.e. /
    URL_SNIP          = /\A\/([\w\-]+)(\/|\.(\w+))?\Z/            # i.e. /start, /start.html
    URL_SNIP_AND_PART = /\A\/([\w\-]+)\/([\w\-]+)(\/|\.(\w+))?\Z/ # i.e. /blah/part, /blah/part.raw
    
    # Returns an array of the requested snip, part and format
    def request_uri_parts(request)
      case uri_path(request)
      when URL_ROOT
        ['start', nil, 'html']
      when URL_SNIP
        [$1, nil, $3]
      when URL_SNIP_AND_PART
        [$1, $2, $4]
      else
        []
      end
    end
  end
end