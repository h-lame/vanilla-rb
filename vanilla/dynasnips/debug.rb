require 'vanilla/dynasnip'

# If the dynasnip is a subclass of Dynasnip, it has access to the request hash
# (or whatever - access to some object outside of the snip itself.)
class Debug < Dynasnip
  def get(*args)
    app.request.inspect
  end
  
  def post(*args)
    "You posted! " + app.request.inspect
  end
end