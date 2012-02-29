path = File.expand_path "../", __FILE__
APP_PATH = path

require 'bundler/setup'
Bundler.require :default

# configs:
ROOT_URL = "web2srv3"

class FBComments < Sinatra::Base
  require "#{APP_PATH}/config/env"

  configure :development do # use thin start
    register Sinatra::Reloader
    # also_reload ["models/*.rb"]
    set :public_folder, "public"
    set :static, true
  end

  require "#{APP_PATH}/config/env"
  include Voidtools::Sinatra::ViewHelpers

  require "#{APP_PATH}/config/sinatra_env"
  # enable :sessions
  helpers Sinatra::ContentFor

  require "#{APP_PATH}/lib/view_helpers"
  helpers ViewHelpers

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end

  def set_access_ctrl_headers
    referer = if request.referer
      "http://#{URI(request.referer).hostname}"
    else
      "http://#{ROOT_URL}"
    end

    # referer = request.referer =~ /shout/ ? "http://radioshout.mkvd.net" : referer

    origin_hosts = case ENV["RACK_ENV"]
      when "development"  then "http://localhost:3001"
      when "test"         then "127.0.0.1 www.example.com"
      when "production"   then referer
    end
    origin_hosts = request.referer.sub /\/$/, '' if referer
    headers "Access-Control-Allow-Origin" =>  origin_hosts
    headers "Access-Control-Allow-Methods" => "GET, POST, PUT, DELETE, OPTIONS"
    headers "Access-Control-Allow-Credentials" => "true"
  end

  before do
    set_access_ctrl_headers
  end


  get "/fbcomments.js" do
    File.read "#{APP_PATH}/public/js/fbcomments.js"
  end


  # encodeURIComponent("http://localhost:3001/post1)
  # http://localhost:3000/comments/http%3A%2F%2Flocalhost%3A3001%2Fpost1
  get "/posts/:post_id/comments" do |post_id|
    content_type :json
    url = CGI.unescape post_id
    if post = Post.first( url: url )
      post.comments.map{ |c| c.public_attributes }.to_json
    else
      halt 404, { error: "post not found" }.to_json
    end
  end

  get "/blogs/:name/comments" do |url|
    content_type :json
    blog = Blog.first name: params[:name]
    if blog
      Comment.all(post: blog.posts).map{ |c| c.public_attributes }.to_json
    else
      [].to_json
    end
  end

  # NOTE: cool approach but this is not the right scenario for it

  # # url = encodeURIComponent(url)
  # # comment = {
  # #   text: text,
  # #   user_id: user_id
  # # }
  #
  # # curl -d "text=comment_text&user_id=12345" http://localhost:3000/comments/http%3A%2F%2Flocalhost%3A3001%2Fpage1
  #
  # post "/comments/*" do |url|
  #   content_type :json
  #   url = CGI.unescape url
  #   puts params.inspect
  #   post = Post.first( url: url )
  #   unless post
  #     blog = Blog.first( name: params[:blog] )
  #     blog = Blog.create( name: params[:blog] ) unless blog
  #     post = blog.posts.create( url: url )
  #   end
  #
  #   if post
  #     comment = post.comments.create(
  #       text: params[:text],
  #       user_id: params[:user_id],
  #     )
  #     if comment
  #       { success: "comment inserted" }.to_json
  #     else
  #       halt 500, { error: "error creating the comment" }.to_json
  #     end
  #   else
  #     halt 500, { error: "cannot create post" }.to_json
  #   end
  # end
  #
  # # curl -X DELETE http://localhost:3000/comments/2
  #
  # delete "/comments/:id" do
  #   content_type :json
  #   comment = Comment.get params[:id]
  #   if comment
  #     comment.destroy
  #     { success: "comment '#{params[:id]}' deleted" }.to_json
  #   else
  #     halt 404, { error: "comment not found" }.to_json
  #   end
  # end

  get "/" do
    haml :index
  end

end