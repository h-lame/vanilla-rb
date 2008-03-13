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
require 'vanilla/dynasnips'

module Vanilla
  # Expects params to include
  #   :snip => the name of the snip [REQUIRED]
  #   :part => the part of the snip to show [OPTIONAL]
  #
  def self.present(params)
    case params[:format]
    when 'html', nil
      # render in main template
      Vanilla::Render.render('system', :main_template, [], params, Vanilla::Render::Erb)
    when 'raw'
      # Return the raw content of the snip (or snip part)
      Vanilla::Render.render(params[:snip], params[:part] || :content, [], params, Vanilla::Render::Raw)
    when 'text'
      # Render the content of this snip, but without recursing into other snips
      Vanilla::Render.render_without_including_snips(params[:snip], params[:part] || :content, [], params)
    else
      "Unknown format '#{params[:format]}'"
    end
  end
end