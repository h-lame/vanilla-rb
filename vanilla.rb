$LOAD_PATH << "lib"

require 'rubygems'
require 'soup'
require 'vanilla/routes'
require 'vanilla/render'
require 'vanilla/dynasnip'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)

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