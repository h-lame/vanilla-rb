require 'vanilla/render'

module Vanilla::Render
  class Bold < Base
    def process_text(snip, content, args)
      "<b>#{content}</b>" 
    end
  end
end