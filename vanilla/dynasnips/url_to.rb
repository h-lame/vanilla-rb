dynasnip "url_to", %{
  class UrlTo
    def get(snip_name)
      if Snip[snip_name]
        Vanilla::Routes.url_to(snip_name)
      else
        "[Snip '\#{snip_name}' not found]"
      end
    end
  end
  UrlTo  
}