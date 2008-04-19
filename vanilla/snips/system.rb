system = Snip['system'] || Snip.new(:name => "system")
system.content = "You're in the system snip now. You probably want to {edit_link system,edit} it though."

system.main_template = <<-HTML
<html>
<head>
  <title>{current_snip name}</title>
  <script language="javascript" src="/public/javascripts/jquery-1.2.3.js" />
  <script language="javascript" src="/public/javascripts/vanilla.js" />
  <link rel="stylesheet" type="text/css" media="screen"  href="<%= Vanilla::Routes.url_to_raw("system", "css") %>" />
</head>
<body>
  <div id="content">
    <div id="controls">
      <strong><a href="/">home</a></strong>, 
      <%= Vanilla::Routes.new_link %> ::
      <strong>{link_to_current_snip}</strong> &rarr; 
      <%= Vanilla::Routes.edit_link("{current_snip name}", "Edit") %>
    </div>
    {current_snip}
  </div>
</body>
</html>
HTML

system.four_oh_four = <<-HTML
<h1>DANG IT!</h1>
<p>That is too bad. DANG that smarts bad. I couldn't load your request. Was it malformed?</p>
<p>Maybe you should go <a href="/">home</a>.</p>
HTML

system.css = <<-CSS
body {
  font-family: Helvetica;
  background-color: #666;
  margin: 0;
  padding: 0;
}

div#content {
  width: 600px;
  margin: 0 auto;
  background-color: #fff;
  padding: 1em;
}

div#controls {
font-size: 80%;
padding-bottom: 1em;
margin-bottom: 1em;
border-bottom: 1px solid #999;
}

textarea {
  width: 100%;
}

textarea.content {
  min-height: 10em;
}

pre {
  background-color: #f6f6f6;
  border: 1px solid #ccc;
  padding: 1em;
}

a.new {
  background-color: #f0f0f0;
  text-decoration: none;
  color: #999;
  padding: 0.2em;
}

a.new:hover {
  text-decoration: underline;
}
CSS

system.save