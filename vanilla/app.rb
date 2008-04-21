require 'vanilla'

module Vanilla
  class App
    
    attr_reader :request
    
    def initialize(request)
      @request = request
    end

    # Params should be the HTTP query parameters as a symbolized Hash, 
    # but can/should include:
    #   :snip => the name of the snip [REQUIRED]
    #   :part => the part of the snip to show [OPTIONAL]
    #   :format => the format to render [OPTIONAL]
    #   :method => GET/POST/DELETE/PUT [OPTIONAL]
    #
    def present
      puts "presenting: #{request.format}"
      case request.format
      when 'html', nil
        render('system', :main_template, request.params, [], Renderers::Erb)
      when 'raw'
        render(request.snip, request.part || :content, request.params, [], Renderers::Raw)
      when 'text'
        render(request.snip, request.part || :content, request.params, [])
      else
        "Unknown format '#{request.format}'"
      end
    end

    # render a snip using either the renderer given, or the renderer
    # specified by the snip's "render_as" property, or Render::Base
    # if nothing else is given.
    def render(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
      rendering(snip_name, snip_part, context, args, renderer) do |r|
        r.render
      end
    end

    # Render a snip using its given renderer, but do not perform any snip
    # inclusion. I.e., ignore {snip arg} blocks of text in the snip content.
    def render_without_including_snips(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
      rendering(snip_name, snip_part, context, args, renderer) do |r|
        r.render_without_including_snips
      end
    end

    # Returns the renderer class for a given snip
    def renderer_for(snip)
      return Renderers::Base unless snip.render_as
      Vanilla::Renderers.const_get(snip.render_as)
    end

    # Given the snip and parameters, yield the appropriate Vanilla::Render::Base subclass
    # instance
    def rendering(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
      snip = Snip[snip_name]
      if snip
        new_renderer = renderer || renderer_for(snip)
        part_to_render = snip_part || :content
        puts "creating new #{new_renderer.name} for '#{snip_name}'"
        renderer_instance = new_renderer.new(self, snip, part_to_render, context, args)
        yield renderer_instance
      else
        "[Snip '#{snip_name}' does not exist]"
      end
    rescue Exception => e
      "<pre>[Error rendering '#{snip_name}' - \"" + 
        e.message.gsub("<", "&lt;").gsub(">", "&gt;") + "\"]\n" + 
        e.backtrace.join("\n").gsub("<", "&lt;").gsub(">", "&gt;") + "</pre>"
    end
    
  end
end