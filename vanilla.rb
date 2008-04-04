require 'rubygems'

# In case we haven't upgraded Rubygems yet
unless Kernel.respond_to?(:gem)
  def gem(*args)
    require_gem(*args)
  end
end

gem 'soup', '>= 0.1.4'
require 'soup'

module Vanilla
  # Params should be the HTTP query parameters as a symbolized Hash, 
  # but can/should include:
  #   :snip => the name of the snip [REQUIRED]
  #   :part => the part of the snip to show [OPTIONAL]
  #   :format => the format to render [OPTIONAL]
  #   :method => GET/POST/DELETE/PUT [OPTIONAL]
  #
  def self.present(params)
    case params[:format]
    when 'html', nil
      render('system', :main_template, params, [], Renderers::Erb)
    when 'raw'
      render(params[:snip], params[:part] || :content, params, [], Renderers::Raw)
    when 'text'
      render(params[:snip], params[:part] || :content, params, [])
    else
      "Unknown format '#{params[:format]}'"
    end
  end
  
  # Returns the renderer class for a given snip
  def self.renderer_for(snip)
    return Renderers::Base unless snip.render_as
    Vanilla::Renderers.const_get(snip.render_as)
  end

  def self.rendering(snip_name, snip_part=:content, context={}, args=[], renderer=nil)
    snip = Snip[snip_name]
    if snip
      new_renderer = renderer || renderer_for(snip)
      part_to_render = snip_part || :content
      renderer_instance = new_renderer.new(snip, part_to_render, context, args)
      yield renderer_instance
    else
      "[Snip '#{snip_name}' does not exist]"
    end
  rescue Exception => e
    "<pre>[Error rendering '#{snip_name}' - \"" + e.message + "\"]\n" + e.backtrace.join("\n") + "</pre>"
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

def dynasnip(*args)
  # do nothing
end
def snip(*args)
  # do nothing
end

# Load all the other renderer subclasses
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'renderers', '*.rb')].each { |f| require f }  

# Load the routing information
require 'vanilla/routes'

# Load all the base dynasnip classes
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'dynasnips', '*.rb')].each do |dynasnip|
  require dynasnip
end