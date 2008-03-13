require 'vanilla/dynasnip'

module Vanilla
  module Dynasnips
    class NewSnip < Dynasnip
      def handle(*arg)
        Render.render('edit', :template, [], context.merge(:snip_to_edit => 'blank'), Render::Erb)
      end
    end
    
    class EditSnip < Dynasnip
      def handle(*args)
        raw_edit_template = Vanilla::Render.render_without_including_snips('edit', :template, [], context, Vanilla::Render::Erb)
        prevent_snip_inclusion(raw_edit_template)
      end
    end
    
    class EditLink
      def handle(snip_name, link_text)
        Vanilla::Routes.edit_link(snip_name, link_text)
      end
    end
    
    class UrlTo
      def handle(snip_name)
        Snip[snip_name] ? Vanilla::Routes.url_to(snip_name) : "[Snip '\#{snip_name}' not found]"
      end
    end
    
    class LinkTo
      def handle(snip_name)
        Snip[snip_name] ? Vanilla::Routes.link_to(snip_name) : Vanilla::Routes.new_link(snip_name)
      end
    end

    class LinkToCurrentSnip < Dynasnip
      def handle(*args)
        if context[:snip] == 'edit' # we're editing so don't use this name
          Vanilla::Routes.link_to context[:snip_to_edit]
        else
          Vanilla::Routes.link_to context[:snip]
        end
      end    
    end
    
    class Debug < Dynasnip
      def handle(*args)
        context.inspect
      end
    end
    
    class ShowContentInPreTag
      def handle(snip_name)
        %{<pre>\#{Snip[snip_name].content}</pre>}
      end
    end
    
    class CurrentSnip < Dynasnip
      def handle(*args)        
        if args[0] == 'name'
          if context[:snip] == 'edit' # we're editing so don't use this name
            context[:snip_to_edit]
          else
            context[:snip]
          end
        else
          Vanilla::Render.render(context[:snip], context[:part], args, context)
        end
      end
    end
    
    class SaveSnip < Dynasnip
      def handle(*args)
        snip_attributes = context.dup
        snip_attributes.delete(:save_button)
        snip_attributes.delete(:snip)
        snip_attributes.delete(:format)

        return 'no params' if snip_attributes.empty?
        snip = Snip[snip_attributes[:name]]
        snip_attributes.each do |name, value|
          snip.__send__(:set_value, name, value)
        end
        snip.save
        %{Saved snip \#{Vanilla::Routes.link_to snip_attributes[:name]} ok}
      rescue Exception => e
        p snip_attributes
        Snip.new(snip_attributes).save
        %{Created snip \#{Vanilla::Routes.link_to snip_attributes[:name]} ok}
      end
    end
    
    class RandomNumber
      def handle(min=1, max=100)
        # arguments come in as strings, so we need to convert them.
        min = min.to_i
        max = max.to_i
        (rand(max-min) + min)
      end
    end
  end
end

include Vanilla::Dynasnips # TODO: get the Ruby renderer to eval in this module's namespace