$LOAD_PATH << "lib"

require 'rubygems'
require 'soup'
require 'render'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)