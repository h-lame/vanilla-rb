require 'vanilla/dynasnip'

class NewSnip < Dynasnip
  snip_name :new
  
  def handle(*arg)
    Vanilla::Renderers::Erb.new(app).render(Vanilla.snip('edit'), :template)
  end
end