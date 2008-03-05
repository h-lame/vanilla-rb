module Vanilla
  module Routes
    def link_to(snip_name, part=nil)
      %{<a href="#{Vanilla::Routes.url_to(snip_name, part)}">#{snip_name}</a>}
    end
  
    def url_to(snip_name, part=nil)
      url = "/#{snip_name}"
      url += "/#{part}" if part
      url
    end

    def url_to_raw(snip_name, part=nil)
      url = "/#{snip_name}"
      url += "/#{part}" if part
      url += ".raw"
    end
  
    def edit_link(snip_name, link_text)
      %[<a href="/edit?snip_to_edit=#{snip_name}">#{link_text}</a>]
    end
  
    def new_link(snip_name="New")
      %[<a href="/new" class="new">#{snip_name}</a>]
    end
  
    extend self
  end
end