dynasnip "new", %{
class NewSnip < Dynasnip
  def get(*arg)
    Render.render('edit', :template, context.merge(:snip_to_edit => 'blank'), [], Render::Erb)
  end
end
NewSnip
}