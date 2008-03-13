require 'rubygems'

# In case we haven't upgraded Rubygems yet
unless Kernel.respond_to?(:gem)
  def gem(*args)
    require_gem(*args)
  end
end

gem 'soup', '>= 0.1.4'
require 'soup'

require 'vanilla/routes'
require 'vanilla/render'
require 'vanilla/dynasnip'

module Vanilla
  def self.present(params, snip_name, part=nil)
    case params[:format]
    when 'html', nil
      # render in main template
      Vanilla::Render.render('system', :main_template, [], params, Vanilla::Render::Erb)
    when 'raw'
      # Return the raw content of the snip (or snip part)
      Vanilla::Render.render(snip_name, part || :content, [], params, Vanilla::Render::Raw)
    when 'text'
      # Render the content of this snip, but without recursing into other snips
      Vanilla::Render.render_without_including_snips(snip_name, part || :content, [], params)
    else
      "Unknown format '#{params[:format]}'"
    end
  end
end