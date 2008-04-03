require 'vanilla'

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rvanilla"
end

def load_snips(kind)
  Dir[File.join(File.dirname(__FILE__), kind, '*.rb')].each do |f|
    puts "loading #{f}"
    load f
  end
end

task :bootstrap do
  Soup.prepare 
  
  require File.join(File.dirname(__FILE__), *%w[snip_helper])

  Dynasnip.persist_all!
  load_snips('snips')
  
  load File.join(File.dirname(__FILE__), *%w[test_snips.rb])
  
  puts "Loaded #{Soup.tuple_class.count} tuples"
end