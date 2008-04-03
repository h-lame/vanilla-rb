class NewSnip < Dynasnip
  snip_name :new
  
  def handle(*arg)
    Render.render('edit', :template, context.merge(:snip_to_edit => 'blank'), [], Render::Erb)
  end
end