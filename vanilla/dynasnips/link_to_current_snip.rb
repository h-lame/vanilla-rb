require 'vanilla/dynasnip'

class LinkToCurrentSnip < Dynasnip
  usage %|
    Renders a link to the current snip, or the snip currently being edited 
    (if we're currently editing)
  |
  
  def handle(*args)
    if context[:snip] == 'edit' # we're editing so don't use this name
      Vanilla::Routes.link_to context[:snip_to_edit]
    else
      Vanilla::Routes.link_to context[:snip]
    end
  end    
end