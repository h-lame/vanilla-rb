require 'vanilla/render'

class Dynasnip < Vanilla::Render::Base
  # This lets dynasnips refer to Render.render, rather than Vanilla::Render.render
  include Vanilla
  
  # dynasnips gain access to the context in the same way as Render::Base
  # subclasses
end