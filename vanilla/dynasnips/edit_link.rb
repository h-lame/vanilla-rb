dynasnip "edit_link", %{
class EditSnipLink
  def get(snip_name, link_text)
    Vanilla::Routes.edit_link(snip_name, link_text)
  end
end
EditSnipLink}