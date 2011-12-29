# fetch comments from fb and save to db
path = File.expand_path "../../", __FILE__


require "#{path}/config/env"


puts Post.first