require 'rubygems'

# In case we haven't upgraded Rubygems yet
unless Kernel.respond_to?(:gem)
  def gem(*args)
    require_gem(*args)
  end
end

gem 'soup', '>= 0.1.4'
require 'soup'

require 'vanilla/render_result'

module Vanilla
  # Params should be the HTTP query parameters as a symbolized Hash, 
  # but can/should include:
  #   :snip => the name of the snip [REQUIRED]
  #   :part => the part of the snip to show [OPTIONAL]
  #   :format => the format to render [OPTIONAL]
  #   :method => GET/POST/DELETE/PUT [OPTIONAL]
  #
  def self.present(params)
    render_result = Vanilla::RenderResult.new
    case params[:format]
    when 'html', nil
      render('system', :main_template, params, [], render_result, Renderers::Erb)
    when 'raw'
      render(params[:snip], params[:part] || :content, params, [], render_result, Renderers::Raw)
    when 'text'
      render(params[:snip], params[:part] || :content, params, [], render_result)
    else
      render_result.failure("Unknown format '#{params[:format]}'")
    end
    render_result
  end
  
  # Returns the renderer class for a given snip
  def self.renderer_for(snip)
    return Renderers::Base unless snip.render_as
    Vanilla::Renderers.const_get(snip.render_as)
  end

  def self.rendering(snip_name, snip_part=:content, context={}, args=[], render_result=Vanilla::RenderResult.new, renderer=nil)
    snip = Snip[snip_name]
    snip_part = (snip_part || :content)
    if (snip && snip.respond_to?(snip_part))
      new_renderer = renderer || renderer_for(snip)
      part_to_render = snip_part
      renderer_instance = new_renderer.new(snip, part_to_render, context, args, render_result)
      yield renderer_instance
    else
      render_result.missing(if snip
                              "[Snip does not exist: #{snip_name}/#{snip_part}]"
                            else
                              "[Snip does not exist: #{snip_name}]"
                            end)
    end
  rescue Exception => e
    render_result.failure "<pre>[Error rendering '#{snip_name}' - \"" + e.message + "\"]\n" + e.backtrace.join("\n") + "</pre>"
  end

  # render a snip using either the renderer given, or the renderer
  # specified by the snip's "render_as" property, or Render::Base
  # if nothing else is given.
  def self.render(snip_name, snip_part=:content, context={}, args=[], render_result=Vanilla::RenderResult.new, renderer=nil)
    rendering(snip_name, snip_part, context, args, render_result, renderer) do |r|
      render_result.rendered_content = r.render
    end
    render_result
  end

  def self.render_without_including_snips(snip_name, snip_part=:content, context={}, args=[], render_result=Vanilla::RenderResult.new, renderer=nil)
    rendering(snip_name, snip_part, context, args, render_result, renderer) do |r|
      render_result.rendered_content = r.render_without_including_snips
    end
    render_result
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