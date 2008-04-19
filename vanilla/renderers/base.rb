module Vanilla
  module Renderers
    class Base
      
      # This is synonymous to creating a new instance of the Renderer, and then
      # passing it the same arguments (except the snip, rather than the snip name,
      # is passed).
      def self.render(snip_name, snip_part=:content, context={}, args=[])
        snip = Snip[snip_name]
        new(snip, snip_part, context, args).render
      end
      
      def self.escape_curly_braces(str)
        str.gsub("{", "&#123;").gsub("}", "&#125;")
      end
      
      attr_reader :context, :snip, :part, :args
    
      def initialize(snip, snip_part=:content, context={}, args=[])
        @context = context
        @snip = snip
        @part = snip_part
        @args = args
      end
    
      # Handles processing the text of the content. Subclasses should
      # override this method to do fancy text processing like markdown
      # or loading the content as Ruby code.
      def process_text(snip, content, args)
        content
      end
    
      def self.snip_regexp
        %r{ \{
          ([\w\-]+) (?: \.([\w\-]+) )?
          (?: \s+ ([\w\-,]+) )?
        \} }x
      end
    
      # Default behaviour to include a snip's content
      def include_snips(content)
        content.gsub(Vanilla::Renderers::Base.snip_regexp) do
          snip_name = $1
          snip_attribute = $2
          snip_args = $3 ? $3.split(',') : []
          
          # Render the snip or snip part with the given args, and the current
          # context, but with the default renderer for that snip. We dispatch
          # *back* out to the root Vanilla.render method to do this.
          Vanilla.render(snip_name, snip_attribute, @context, snip_args)
        end
      end
    
      def render_without_including_snips
        process_text(@snip, raw_content, @args)
      end

      # Returns the raw content for the selected part of the selected snip
      def raw_content
        @snip.__send__(@part)      
      end
    
      # Default rendering behaviour. Subclasses shouldn't really need to touch this.
      def render
        processed_text = process_text(@snip, raw_content, @args)
        include_snips(processed_text)
      end
    end
  end
end