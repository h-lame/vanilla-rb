require 'rubygems'
require 'sinatra'
require 'vanilla'

Sinatra::StaticEvent::MIME_TYPES.merge!({'' => 'text/plain'})
Sinatra::StaticEvent::MIME_TYPES.merge!({'js' => 'text/javascript'})

static('/public', 'vanilla/public')

Soup.prepare

# BAD Sinatra, SILLY Sinatra.  Polute my namespace at your peril.
# Removing the DSL methods from Renderers as these names will clash with how we allow
# dyna to be kinda little slices of REST on their own.  Might want to nobble other
# Sinatra DSL methods too.  Also from other classes.
Vanilla::Renderers::Base.class_eval {
  undef_method :get if instance_methods.include? 'get'
  undef_method :put if instance_methods.include? 'put'
  undef_method :post if instance_methods.include? 'post'
  undef_method :delete if instance_methods.include? 'delete'
}

get('/') { redirect Vanilla::Routes.url_to('start') }
['get', 'post', 'put', 'delete'].each do |method|
  send(method, '/:snip.:format') do
    params.update(:method => method)
    Vanilla.present params
  end
  send(method, '/:snip/:part.:format') do
    params.update(:method => method)
    Vanilla.present params
  end
end