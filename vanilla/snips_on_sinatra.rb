require 'rubygems'
require 'sinatra'
require 'vanilla'

Sinatra::StaticEvent::MIME_TYPES.merge!({'' => 'text/plain'})
Sinatra::StaticEvent::MIME_TYPES.merge!({'js' => 'text/javascript'})

static('/public', 'vanilla/public')

Soup.prepare

get('/') { redirect Vanilla::Routes.url_to('start') }
get('/:snip') { Vanilla.present params }
get('/:snip/:part') { Vanilla.present params }
