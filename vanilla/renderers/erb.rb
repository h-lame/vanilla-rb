require 'vanilla/renderers/base'

require 'erb'
include ERB::Util

module Vanilla::Renderers
  class Erb < Base
    def process_text(snip, content, args)
      ERB.new(content).result(binding)
    end
  end
end