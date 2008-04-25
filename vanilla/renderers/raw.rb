require 'vanilla/renderers/base'

module Vanilla::Renderers
  class Raw < Base
    def render(snip, part=:content)
      raw_content(snip, part)
    end
  end
end