dynasnip "link_to", %{
class Linker
  def get(snip_name)
    if Snip[snip_name]
      Vanilla::Routes.link_to(snip_name)
    else
      Vanilla::Routes.new_link(snip_name)
    end
  end
end
Linker}