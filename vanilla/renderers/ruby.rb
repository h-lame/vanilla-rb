require 'vanilla/render'

module Vanilla::Render
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
    def process_text(snip, content, args)
      handler_klass = eval(content, binding, snip.name)
      instance = if handler_klass.ancestors.include?(Vanilla::Render::Base)
        handler_klass.new(snip, nil, context, args)
      else
        handler_klass.new
      end
      if context[:method] && instance.respond_to?(context[:method])
        instance.send(context[:method], *args).to_s
      else
        instance.handle(*args).to_s
      end
    end
  end
end
