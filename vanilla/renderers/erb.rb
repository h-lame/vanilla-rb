require 'vanilla/renderers/base'

require 'erb'
include ERB::Util

module Vanilla::Renderers
  class Erb < Base
    def render(snip, part=:content) #, args=[])
      @snip = snip # make the snip available to the context
      processed_text = render_without_including_snips(snip, part) #, args)
      include_snips(processed_text)
    end
    
    def process_text(content)
      ERB.new(content).result(binding)
    end
  end
end