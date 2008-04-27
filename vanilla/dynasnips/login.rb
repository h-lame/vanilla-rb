require 'vanilla/dynasnip'
require 'yaml'
require 'md5'

class Login < Dynasnip
  module Helper
    def logged_in?
      !app.request.cookies['logged_in_as'].nil?
    end
  
    def login_required
      "You need to <a href='/login'>login</a> to do that."
    end
  end
  include Helper
  
  def get(*args)
    if logged_in?
      login_controls
    else
      render(self, 'template')
    end
  end
  
  def post(*args)
    credentials = YAML.load(File.open("vanilla-authorization.yml"))
    if credentials[cleaned_params[:name]] == MD5.md5(cleaned_params[:password]).to_s
      app.response.set_cookie('logged_in_as', cleaned_params[:name])
      app.request.cookies['logged_in_as'] = cleaned_params[:name]
      login_controls
    else
      "login fail!"
    end
  end
  
  def delete(*args)
    app.response.delete_cookie('logged_in_as')
    "Logged out"
  end
  
  attribute :template, <<-EHTML
    <form action='/login' method='post'>
    <label>Name: <input type="text" name="name"></input></label>
    <label>Password: <input type="password" name="password"></input></label>
    <button>login</button>
    </form>
  EHTML
  
  private
  
  def login_controls
    "logged in as {link_to #{app.request.cookies['logged_in_as']}}; <a href='/login?_method=delete'>logout</a>"
  end
end