require 'vanilla/renderers/base'

require 'rubygems'
gem 'BlueCloth' # from http://www.deveiate.org/projects/BlueCloth
require 'bluecloth'

module Vanilla::Renderers
  class Markdown < Base
    def process_text(content)
      BlueCloth.new(content).to_html
    end
  end
end