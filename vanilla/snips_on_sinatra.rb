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

static('/public', 'vanilla/public')

get('/') { redirect Vanilla::Routes.url_to('start') }
get('/:snip') { Vanilla.present params, params[:snip] }
get('/:snip/:part') { Vanilla.present params, params[:snip], params[:part] }
