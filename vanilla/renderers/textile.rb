require 'vanilla/renderers/base'

require 'rubygems'
gem 'RedCloth'
require 'redcloth'

module Vanilla::Renderers
  class Textile < Base
    def process_text(content)
      RedCloth.new(content).to_html
    end
  end
end