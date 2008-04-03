# The edit dyna will load the snip given in the 'snip_to_edit' part of the
# params
class EditSnip < Dynasnip
  snip_name "edit"
  
  def get(*args)
    snip_in_edit_template = Render.render_without_including_snips('edit', :template, context, [], Render::Erb)
    prevent_snip_inclusion(snip_in_edit_template)
  end
  
  def post(*args)
    snip_attributes = cleaned_params
    snip_attributes.delete(:save_button)

    return 'no params' if snip_attributes.empty?
    snip = Snip[snip_attributes[:name]]
    snip_attributes.each do |name, value|
      snip.__send__(:set_value, name, value)
    end
    snip.save
    %{Saved snip #{Vanilla::Routes.link_to snip_attributes[:name]} ok}
  rescue Exception => e
    p snip_attributes
    Snip.new(snip_attributes).save
    %{Created snip #{Vanilla::Routes.link_to snip_attributes[:name]} ok}
  end
  
  private
  
  def prevent_snip_inclusion(content)
    content.gsub("{", "&#123;").gsub("}" ,"&#125;")
  end
  
  attribute :template, %{
    <form action="<%= Vanilla::Routes.url_to 'edit' %>" method="post">
    <dl class="attributes">
      <% snip_to_edit = Snip[context[:snip_to_edit]] %>
      <% snip_to_edit.attributes.each do |name, value| %>
      <dt><%= name %></dt>
      <% num_rows = value.split("\n").length + 1 %>
      <dd><textarea name="<%= name %>" rows="<%= num_rows %>"><%=h value %></textarea></dd>
      <% end %>
      <dt><input class="attribute_name" type="text"></input></dt>
      <dd><textarea></textarea></dd>
    </dl>
    <a href="#" id="add">Add</a>
    <button name='save_button'>Save</button>
    </form>
  }
end