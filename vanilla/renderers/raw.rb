require 'vanilla/renderers/base'

module Vanilla::Renderers
  class Raw < Base
    def render
      raw_content
    end
  end
end