$LOAD_PATH << "lib"

require 'rubygems'
require 'soup'
require 'vanilla/routes'
require 'vanilla/render'
require 'vanilla/dynasnip'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)