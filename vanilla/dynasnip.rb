require 'vanilla/render'
require 'enumerator'

class Dynasnip < Vanilla::Render::Base
  # This lets dynasnips refer to Render.render, rather than Vanilla::Render.render
  include Vanilla
  
  def self.all
    ObjectSpace.enum_for(:each_object, class << self; self; end).to_a - [self]
  end
  
  def self.snip_name(new_name=nil)
    if new_name
      @snip_name = new_name.to_s
    else
      # borrowed from ActiveSupport
      @snip_name ||= self.name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
  
  def self.attribute(attribute_name, attribute_value)
    @attributes ||= {}
    @attributes[attribute_name.to_sym] = attribute_value
  end
  
  def self.persist_all!
    all.each do |dynasnip|
      dynasnip.persist!
    end
  end
  
  def self.persist!
    snip_attributes = {:name => snip_name, :content => self.name, :render_as => "Ruby"}
    snip_attributes.merge!(@attributes) if @attributes
    Snip.new(snip_attributes).save
  end
  
  # dynasnips gain access to the context in the same way as Render::Base
  # subclasses
  
  protected
  
  def cleaned_params
    p = context.dup
    p.delete(:snip)
    p.delete(:format)
    p.delete(:method)
    p.delete(:part)
    p
  end
end