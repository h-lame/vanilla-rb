require 'rubygems'
require 'sinatra'
require 'vanilla'

require 'erb'
include ERB::Util

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)

Sinatra::StaticEvent::MIME_TYPES.merge!({'' => 'text/plain'})
Sinatra::StaticEvent::MIME_TYPES.merge!({'js' => 'text/javascript'})

helpers do
  def present(snip_name, part=nil)
    case params[:format]
    when 'html'
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

static('/public', 'vanilla/public')

get('/') { redirect Vanilla::Routes.url_to('start') }
get('/:snip') { present params[:snip] }
get('/:snip/:part') { present params[:snip], params[:part] }
