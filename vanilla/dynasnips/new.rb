require 'vanilla/dynasnip'

class NewSnip < Dynasnip
  snip_name :new
  
  def handle(*arg)
    Vanilla.render('edit', :template, context.merge(:snip_to_edit => 'blank'), [], Vanilla::Renderers::Erb)
  end
end