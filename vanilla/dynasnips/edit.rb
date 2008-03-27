# The edit dyna will load the snip given in the 'snip_to_edit' part of the
# params
dynasnip "edit", %{
  class EditSnip < Dynasnip
    def get(*args)
      snip_in_edit_template = Render.render_without_including_snips('edit', :template, context, [], Render::Erb)
      prevent_snip_inclusion(snip_in_edit_template)
    end
    
    private
    
    def prevent_snip_inclusion(content)
      content.gsub("{", "&#123;").gsub("}" ,"&#125;")
    end
  end
  EditSnip
}, :template => %{
  <form action="<%= Vanilla::Routes.url_to "save" %>">
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
}, :render_as => "Ruby"