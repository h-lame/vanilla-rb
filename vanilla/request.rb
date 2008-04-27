require "cgi"

module Vanilla
  # Create a request with symbolised access to the params, and some special
  # accessors to the snip, part and format based on our routing.
  class Request
    attr_reader :snip_name, :part, :format, :method
    
    def initialize(rack_request, dreamhost_fix = false)
      @rack_request = rack_request
      @dreamhost_fix = dreamhost_fix
      determine_request_uri_parts
    end

    def params
      # Don't you just love how terse functional programming tends to look like maths?
      @symbolised_params ||= @rack_request.params.inject({}) { |p, (k,v)| p[k.to_sym] = v; p }
    end
    
    # Returns the snip referenced by the request's URL. Performs no exception
    # handling, so if the snip does not exist, an exception will be thrown.
    def snip
      Vanilla.snip(snip_name)
    end
    
    def cookies
      @rack_request.cookies
    end
    
    private
    
    def determine_request_uri_parts
      @snip_name, @part, @format = request_uri_parts(@rack_request)
      @format ||= 'html'
      @method = (params.delete(:_method) || @rack_request.request_method).downcase
    end
    
    # TODO: this is ugly, but cgi on dreamhost doesn't give anything in path_info
    def uri_path(request)
      @dreamhost_fix ? request.env["SCRIPT_URL"] : request.path_info
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
end  