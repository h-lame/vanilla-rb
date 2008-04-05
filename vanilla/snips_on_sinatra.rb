require 'rubygems'
require 'sinatra'
require 'vanilla'

Sinatra::StaticEvent::MIME_TYPES.merge!({'' => 'text/plain'})
Sinatra::StaticEvent::MIME_TYPES.merge!({'js' => 'text/javascript'})

static('/public', 'vanilla/public')

Soup.prepare

get('/') { redirect Vanilla::Routes.url_to('start') }
['get', 'post', 'put', 'delete'].each do |method|
  send(method, '/:snip.:format') do
    Vanilla.present sort_out_the_params_you_muppet(params, method)
  end
  send(method, '/:snip/:part.:format') do
    Vanilla.present sort_out_the_params_you_muppet(params, method)
  end
end

def sort_out_the_params_you_muppet(params ={}, method = 'get')
  [:snip, :part, :format].each do |url_bit|
    params[url_bit] = CGI.unescape(params[url_bit]) unless params[url_bit].nil?
  end
  params[:method] = method
  params
end