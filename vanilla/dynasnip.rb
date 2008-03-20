require 'vanilla/render'

class Dynasnip < Vanilla::Render::Base
  include Vanilla
  # dynasnips gain access to the context in the same way as Render::Base
  # subclasses
end