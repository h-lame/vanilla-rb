require 'vanilla/dynasnip'

class LinkTo < Dynasnip
  usage %|
The link_to dyna lets you create links between snips: 

  {link_to blah} 

would insert a link to the blah snip.|

  def handle(snip_name)
    Vanilla.snip_exists?(snip_name) ? Vanilla::Routes.link_to(snip_name) : Vanilla::Routes.new_link(snip_name)
  end
end