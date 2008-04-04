$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[..])
require "vanilla"
require "spec"

module Vanilla
  module Test
    def self.setup_clean_environment
      test_soup_config = { :database => File.join(File.dirname(__FILE__), "soup_test.db")}
      FileUtils.rm(test_soup_config[:database]) if File.exist?(test_soup_config[:database])
      Soup.base = test_soup_config

      # TODO: this is hard-coded for the AR implementation
      require "active_record"
      ActiveRecord::Migration.verbose = false
  
      Soup.prepare
    end
  end
end

def create_snip(params)
  s = Snip.new(params)
  s.save
  s
end