require 'vanilla'

gem 'rack'
require 'rack'


module Vanilla
  class RackApp
    
    # Create a request with symbolised access to the params
    class Request < Rack::Request
      attr_reader :snip, :part, :format
      
      def initialize(env, dreamhost_fix = false)
        super(env)
        @dreamhost_fix = dreamhost_fix
        determine_request_uri_parts
      end

      def params
        # Don't you just love how terse functional programming tends to look like maths?
        @symbolised_params ||= super.inject({}) { |p, (k,v)| p[k.to_sym] = v; p }
      end
      
      def method
        request.request_method.downcase
      end
      
      private
      
      def determine_request_uri_parts
        @snip, @part, @format = request_uri_parts(self)
      end
      
      # TODO: this is ugly, but cgi on dreamhost doesn't give anything in path_info
      def uri_path(request)
        @dreamhost_fix ? env["SCRIPT_URL"] : request.path_info
      end
      
      URL_ROOT          = /\A\/\Z/                                  # i.e. /
      URL_SNIP          = /\A\/([\w\-\s]+)(\/|\.(\w+))?\Z/            # i.e. /start, /start.html
      URL_SNIP_AND_PART = /\A\/([\w\-\s]+)\/([\w\-\s]+)(\/|\.(\w+))?\Z/ # i.e. /blah/part, /blah/part.raw
      
      # Returns an array of the requested snip, part and format
      def request_uri_parts(request)
        case CGI.unescape(uri_path(request))
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
    
    # Create a new Vanilla Rack Application.
    # Set the dreamhost_fix parameter to true to get the request path from the SCRIPT_URL
    # environment variable, rather than the request.path_info method.
    def initialize(dreamhost_fix=false)
      Soup.prepare
      @dreamhost_fix = dreamhost_fix
    end
    
    # The call method required by all good Rack applications
    def call(env)
      request = Request.new(env, @dreamhost_fix)
      if request.snip
        [200, {"Content-Type" => "text/html"}, [Vanilla::App.new(request).present]]
      else
        # four_oh_four = Vanilla::App.new.present(:snip => 'system', :part => 'four_oh_four', :format => 'html')
        [404, {"Content-Type" => "text/html"}, [four_oh_four]]
      end
    end
  end
end