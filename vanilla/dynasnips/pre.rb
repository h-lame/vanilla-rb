class ShowContentInPreTag < Dynasnip
  snip_name "pre"
  
  def handle(snip_name)
    %{<pre>#{Snip[snip_name].content}</pre>}
  end
end