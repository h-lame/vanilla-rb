require 'vanilla/renderers/base'

require 'erb'
include ERB::Util

module Vanilla::Renderers
  class Erb < Base
    def prepare(snip, part=:content, args=[])
      @snip = snip
    end
    
    def process_text(content)
      ERB.new(content).result(binding)
    end
  end
end