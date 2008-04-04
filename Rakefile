require 'vanilla'

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rvanilla"
end

task :clean do
  # TODO: get the database name from Soup
  FileUtils.rm "soup.db"
end

def load_snips(kind)
  Dir[File.join(File.dirname(__FILE__), 'vanilla', kind, '*.rb')].each do |f|
    puts "loading #{f}"
    load f
  end
end

task :bootstrap do
  Soup.prepare 
  
  require File.join(File.dirname(__FILE__), *%w[vanilla snip_helper])

  Dynasnip.persist_all!
  load_snips('snips')
  
  load File.join(File.dirname(__FILE__), *%w[vanilla test_snips.rb])
  
  puts "Loaded #{Soup.tuple_class.count} tuples"
end

require 'spec'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end

task :default => :spec