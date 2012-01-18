path = File.expand_path "../../", __FILE__

unless defined?(Rspec)
  require 'bundler/setup'
  Bundler.require :models
else
  require "dm-core"
  require "dm-mysql-adapter"
  require "dm-migrations"
end

# sqlite
#
# DataMapper.setup :default, "sqlite://#{APP_PATH}/db/app.sqlite"

# mysql
#
env = ENV["RACK_ENV"] || "development"
if env == "production"
  pass = File.read(File.expand_path "~/.password").strip
  user = "root:#{pass}@" 
end

DataMapper.setup :default, "mysql://#{user}localhost/fbcomments_#{env}"


# DataMapper::Model.raise_on_save_failure = true 

Dir.glob("#{path}/models/*.rb").each do |model|
  require model
end
DataMapper.finalize

require 'voidtools'