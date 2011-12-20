path = File.expand_path "../../", __FILE__

require 'bundler/setup'
Bundler.require :models

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
require 'voidtools'