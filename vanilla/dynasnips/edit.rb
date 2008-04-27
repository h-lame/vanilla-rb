require 'vanilla/dynasnip'
require 'vanilla/dynasnips/login'

# The edit dyna will load the snip given in the 'snip_to_edit' part of the
# params
class EditSnip < Dynasnip
  include Login::Helper
  
  snip_name "edit"
  
  def get(snip_name=nil)
    return login_required unless logged_in?
    snip = Vanilla.snip(snip_name || app.request.params[:snip_to_edit])
    edit(snip)
  end
  
  def post(*args)
    return login_required unless logged_in?
    snip_attributes = cleaned_params
    snip_attributes.delete(:save_button)

    return 'no params' if snip_attributes.empty?
    snip = Vanilla.snip(snip_attributes[:name])
    snip_attributes.each do |name, value|
      snip.__send__(:set_value, name, value)
    end
    snip.save
    %{Saved snip #{Vanilla::Routes.link_to snip_attributes[:name]} ok}
  rescue Exception => e
    p snip_attributes
    Soup << snip_attributes
    %{Created snip #{Vanilla::Routes.link_to snip_attributes[:name]} ok}
  end
  
  def edit(snip)
    renderer = Vanilla::Renderers::Erb.new(app)
    renderer.instance_eval { @snip_to_edit = snip } # hacky!
    snip_in_edit_template = renderer.render_without_including_snips(Vanilla.snip('edit'), :template)
    prevent_snip_inclusion(snip_in_edit_template)
  end
  
  private
  
  def prevent_snip_inclusion(content)
    content.gsub("{", "&#123;").gsub("}" ,"&#125;")
  end
  
  attribute :template, %{
    <form action="<%= Vanilla::Routes.url_to 'edit' %>" method="post">
    <dl class="attributes">
      <% @snip_to_edit.attributes.each do |name, value| %>
      <dt><%= name %></dt>
      <% num_rows = value.split("\n").length + 1 %>
      <dd><textarea name="<%= name %>" class="<%= name %>" rows="<%= num_rows %>"><%=h value %></textarea></dd>
      <% end %>
      <dt><input class="attribute_name" type="text"></input></dt>
      <dd><textarea></textarea></dd>
    </dl>
    <a href="#" id="add">Add</a>
    <button name='save_button'>Save</button>
    </form>
  }
end