require 'vanilla/render'

module Vanilla::Render
  class Raw < Base
    def render
      @snip.__send__(@part)
    end
  end
end