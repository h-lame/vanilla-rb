require 'vanilla/dynasnip'

class UrlTo < Dynasnip
  def handle(snip_name)
    Snip[snip_name] ? Vanilla::Routes.url_to(snip_name) : "[Snip '#{snip_name}' not found]"
  end
end