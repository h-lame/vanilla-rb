require 'vanilla/app'

module Vanilla
  module Renderers
    class Base
      
      # Render something. If a snip is given, the snip's 'content' part
      # will be rendered.
      def self.render(snip, part=:content) #, args=[])
        new(app).render(snip, part) #, args)
      end
      
      def self.escape_curly_braces(str)
        str.gsub("{", "&#123;").gsub("}", "&#125;")
      end
      
      attr_reader :app
    
      def initialize(app)
        @app = app
      end
      
      # Handles processing the text of the content. Subclasses should
      # override this method to do fancy text processing like markdown
      # or loading the content as Ruby code.
      def process_text(content) #, args)
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
          snip = Snip[snip_name]
          app.render(snip, snip_attribute) #, snip_args)
        end
      end
    
      def render_without_including_snips(snip, part=:content) #, args=[])
        process_text(raw_content(snip, part)) #, args)
      end

      # Returns the raw content for the selected part of the selected snip
      def raw_content(snip, part)
        snip.__send__((part || :content).to_sym)
      end
    
      # Default rendering behaviour. Subclasses shouldn't really need to touch this.
      def render(snip, part=:content) #, args=[])
        processed_text = render_without_including_snips(snip, part) #, args)
        include_snips(processed_text)
      end
    end
  end
end