require 'vanilla'

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
    
    def call(env)
      request = Request.new(env)
    
      case request.path_info
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
      end
    
      params = request.params.merge(:snip => snip, :part => part, :format => format)
    
      rendered_output = Vanilla.present(params, snip, part)
    
      [200, {"Content-Type" => "text/html"}, [rendered_output]]
    end
  end
end