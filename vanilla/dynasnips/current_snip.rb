require 'vanilla/dynasnip'

class CurrentSnip < Dynasnip
  def handle(*args)
    if args[0] == 'name'
      if context[:snip] == 'edit' # we're editing so don't use this name
        context[:snip_to_edit]
      else
        context[:snip]
      end
    else
      out = Vanilla.render(context[:snip], context[:part], context, args)
      render_result.success unless out.is_failure?
      out.rendered_content
    end
  end
end