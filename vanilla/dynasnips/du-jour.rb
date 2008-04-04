require 'vanilla/dynasnip'

dynasnip "du-jour", %{
class DuJour < Dynasnip
  def handle(*args)
    Snip.with(:du_jour_entry, "= 'true'").map do |entry| 
      Vanilla::Render.render('du-jour', 'entry_template', {:entry => entry}, [], Vanilla::Render::Erb)
    end
    
    Snip.where { tags.include? 'monkey' }
    Snip.select { |s| s.tags.include? 'monkey' && s.is_du_jour_entry }
  end
end
DuJour},
:render_as => "Ruby",
:entry_template => %{
  <div class="du-jour-entry">
  {<%= context[:entry].name %>}
  </div>
}