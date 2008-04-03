class LinkTo < Dynasnip
  def handle(snip_name)
    Snip[snip_name] ? Vanilla::Routes.link_to(snip_name) : Vanilla::Routes.new_link(snip_name)
  end
end