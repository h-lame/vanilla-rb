require 'vanilla/dynasnip'

class Index < Dynasnip
  def get(*args)
    # TODO: figure out a way around calling Soup/AR methods directly.
    list = Soup.tuple_class.find_all_by_name('name').map { |tuple| 
      "<li>#{Routes.link_to tuple.value}</li>"
    }
    "<ol>#{list}</ol>"
  end
end