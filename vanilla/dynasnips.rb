require 'vanilla/dynasnip'

Dir[File.join(File.dirname(__FILE__), 'dynasnips', '*.rb')].each do |dynasnip|
  load dynasnip
end