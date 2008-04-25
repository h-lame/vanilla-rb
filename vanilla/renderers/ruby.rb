require 'vanilla/renderers/base'

module Vanilla::Renderers
  # Snips that render_as "Ruby" should define a class.
  # The class should have instance methods for any HTTP request methods that the dynasnip
  # should respond to, i.e. get(), post(), and so on.
  # Alternatively, it can respond to 'handle'.
  #
  # The result of the method invocation always has #to_s called on it.
  # The last line of the content should be the name of that class, so that it
  # is returned by "eval" and we can instantiate it.
  # If the dynasnip needs access to the 'context' (i.e. probably the request
  # itself), it should be a subclass of Dynasnip (or define an initializer
  # that accepts the context as its first argument).
  class Ruby < Base
    def prepare(snip, part=:content, args=[])
      @args = args
      @snip = snip
    end
    
    def process_text(content)
      handler_klass = eval(content, binding, @snip.name)
      instance = if handler_klass.ancestors.include?(Vanilla::Renderers::Base)
        handler_klass.new(app)
      else
        handler_klass.new
      end
      if (method = app.request.method) && instance.respond_to?(method)
        instance.send(method, *@args).to_s
      else
        instance.handle(*@args).to_s
      end
    end
  end
end
