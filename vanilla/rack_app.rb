require 'vanilla'

gem 'rack'
require 'rack'


module Vanilla
  class RackApp
    URL_ROOT = /\A\/\Z/
    URL_SNIP = /\A\/([\w\-]+)(\/|\.(\w+))?\Z/
    URL_SNIP_AND_PART = /\A\/([\w\-]+)\/([\w\-]+)(\/|\.(\w+))?\Z/
    
    class Request < Rack::Request
      def params
        original_params = super
        original_params.inject({}) do |symbolized_params, (key,value)|
          symbolized_params[key.to_sym] = value
          symbolized_params
        end
      end
    end
    
    def initialize(dreamhost_fix=false)
      Soup.prepare
      @dreamhost_fix = dreamhost_fix
    end
    
    def call(env)
      request = Request.new(env)
      
      # TODO: this is ugly, but cgi on dreamhost doesn't give anything in path_info
      uri_path = @dreamhost_fix ? env["SCRIPT_URL"] : request.path_info

      # TODO: there must be a better way to get the routing done
      case uri_path
      when URL_ROOT
        snip = 'start'
        format = 'html'
        part = nil
      when URL_SNIP
        snip = $1
        format = $3
        part = nil
      when URL_SNIP_AND_PART
        snip = $1
        part = $2
        format = $4
      else
        return [404, {"Content-Type" => "text/html"}, ["Couldn't match path '#{request.path_info}'"]]
      end
    
      params = request.params.merge(:snip => snip, :part => part, :format => format)
      rendered_output = Vanilla.present(params)
    
      [200, {"Content-Type" => "text/html"}, [rendered_output]]
    end
  end
end