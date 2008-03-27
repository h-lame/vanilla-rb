require 'rubygems'
require 'soup'

module Vanilla
  module Render
    def self.renderer_for(snip)
      snip.render_as ? const_get(snip.render_as) : nil
    end
  
    def self.rendering(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
      snip = Snip[snip_name]
      if snip
        new_renderer = renderer || renderer_for(snip) || Render::Base
        part_to_render = snip_part || :content
        renderer_instance = new_renderer.new(snip, part_to_render, context, args)
        yield renderer_instance
      else
        "[Snip does not exist: #{snip_name}]"
      end
    rescue Exception => e
      "<pre>[Error rendering '#{snip_name}' - \"" + e.message + "\"]" + e.backtrace.join("\n") + "</pre>"
    end
  
    # render a snip using either the renderer given, or the renderer
    # specified by the snip's "render_as" property, or Render::Base
    # if nothing else is given.
    def self.render(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
      rendering(snip_name, snip_part, context, args, renderer) do |r|
        r.render
      end
    end
  
    def self.render_without_including_snips(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
      rendering(snip_name, snip_part, context, args, renderer) do |r|
        r.render_without_including_snips
      end
    end
  end
end

# Load all the other renderer subclasses
require 'vanilla/renderers/base'
Dir[File.join(File.dirname(__FILE__), 'renderers', '*.rb')].each { |f| require f }