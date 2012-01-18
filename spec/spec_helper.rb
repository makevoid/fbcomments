path = File.expand_path "../../", __FILE__

require 'bundler/setup'
Bundler.require :default, :test
require 'capybara/rspec'
Capybara.javascript_driver = :webkit
# Capybara.default_wait_time = 2
# Capybara.app_host = 'http://www.google.com'
# Capybara.run_server = false

def app
  FBComments
end

require "#{path}/fbcomments"
Capybara.app = app


require "rack/test"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end


DataMapper.auto_migrate!


def should_render
  page.status_code.should eq(200)
end

def json_response
  obj = JSON.parse(last_response.body)
  if obj.is_a?(Hash)
    obj.symbolize_keys
  else
    obj
  end  
end

def clear_db
  app::MODELS.each do |model|
    DataMapper.repository(:default).adapter.execute "TRUNCATE TABLE #{model.pluralize}"
  end
end