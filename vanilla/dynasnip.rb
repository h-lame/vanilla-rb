require 'vanilla/renderers/base'
require 'enumerator'

class Dynasnip < Vanilla::Renderers::Base
  # This lets dynasnips refer to Render.render, rather than Vanilla::Render.render
  #include Vanilla
  
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
  
  def self.attribute(attribute_name, attribute_value=nil)
    @attributes ||= {}
    @attributes[attribute_name.to_sym] = attribute_value if attribute_value
    @attributes[attribute_name.to_sym]
  end
  
  def self.usage(str)
    attribute :usage, escape_curly_braces(str).strip
  end
  
  def self.persist_all!
    all.each do |dynasnip|
      dynasnip.persist!
    end
  end
  
  def self.persist!
    snip_attributes = {:name => snip_name, :content => self.name, :render_as => "Ruby"}
    snip_attributes.merge!(@attributes) if @attributes
    snip = Snip.new(snip_attributes).save
    snip
  end
  
  def method_missing(method, *args)
    if part = self.class.attribute(method)
      part
    else
      super
    end
  end
  
  # dynasnips gain access to the context in the same way as Render::Base
  # subclasses
  
  protected
  
  def snip_name
    self.class.snip_name
  end
  
  def snip
    Snip[snip_name]
  end
  
  def show_usage
    if snip.usage
      Vanilla::Renderers::Markdown.render(snip_name, :usage)
    else
      "No usage information for #{snip_name}"
    end
  end
  
  def cleaned_params
    p = app.request.params.dup
    p.delete(:snip)
    p.delete(:format)
    p.delete(:method)
    p.delete(:part)
    p
  end
end