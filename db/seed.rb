path = File.expand_path "../../", __FILE__

require "#{path}/config/env"

DataMapper.auto_migrate!

# seed your db here

BLOGS = [
  {
    name: "wp",
    label: "WordpressBlog",
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "wp_blog",
  }
]


BLOGS.each do |blog|

  blog = Blog.create blog
  post = blog.posts.create name: "post1", url: "http://#{blog[:name]}/page1"
  comment = post.comments.create text: "commment", user_id: 1218562195, created_at: Time.now
  comment = post.comments.create text: "commment 2", user_id: 1218562195, created_at: Time.now

end
