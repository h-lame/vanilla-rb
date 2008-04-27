require 'vanilla/dynasnip'

class NewSnip < Dynasnip
  snip_name :new
  
  def handle(*arg)
    editor = EditSnip.new(app).edit(Snip.new(:name => 'newsnip', :render_as => ''))
  end
end