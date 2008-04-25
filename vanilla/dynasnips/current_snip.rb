require 'vanilla/dynasnip'

class CurrentSnip < Dynasnip
  usage %|
    The current_snip dyna normally returns the result of rendering the snip named by the 
    'snip' value in the parameters. This way, it can be used in templates to place the currently
    requested snip, in its rendered form, within the page.
    
    It can also be used to determine the name of the current snip in a consistent way:
    
      {current_snip name}
      
    will output the name of the current snip, or the name of the snip currently being edited.
  |
  
  def handle(*args)
    if args[0] == 'name'
      if app.request.snip_name == 'edit' # we're editing so don't use this name
        app.request.params[:snip_to_edit]
      else
        app.request.snip_name
      end
    else
      app.render(app.request.snip)
    end
  end
end