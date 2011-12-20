path = File.expand_path "../../", __FILE__

require "#{path}/config/env"

DataMapper.auto_migrate!

# seed your db here

blog = Blog.create name: "test"
post = blog.posts.create name: "post1", url: "http://localhost:3001/page1"
comment = post.comments.create text: "cooommment"
comment = post.comments.create text: "cooommment2"
