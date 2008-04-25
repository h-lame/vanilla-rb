require 'vanilla/renderers/base'

module Vanilla::Renderers
  class Bold < Base
    def process_text(content) #, args)
      "<b>#{content}</b>" 
    end
  end
end