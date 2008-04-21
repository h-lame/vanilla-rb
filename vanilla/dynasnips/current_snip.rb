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
      if context[:snip] == 'edit' # we're editing so don't use this name
        context[:snip_to_edit]
      else
        context[:snip]
      end
    else
      puts "rendering #{context.inspect}"
      app.render(context[:snip], context[:part], context, args)
    end
  end
end