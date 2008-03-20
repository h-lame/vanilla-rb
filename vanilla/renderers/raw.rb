require 'vanilla/render'

module Vanilla::Render
  class Raw < Base
    def render
      raw_content
    end
  end
end