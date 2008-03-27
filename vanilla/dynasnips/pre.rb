dynasnip "pre", <<-EOF
class ShowContentInPreTag
  def get(snip_name)
    %{<pre>\#{Snip[snip_name].content}</pre>}
  end
end
ShowContentInPreTag
EOF