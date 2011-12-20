path = File.expand_path "../", __FILE__
APP_PATH = path

require 'bundler/setup'
Bundler.require :default


class App < Sinatra::Base
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
  enable :sessions
  helpers Sinatra::ContentFor
  
  require "#{APP_PATH}/lib/view_helpers"
  helpers ViewHelpers

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end

  # encodeURIComponent("http://google.com")
  # "http%3A%2F%2Fgoogle.com"
  # http://localhost:3000/comments/http%3A%2F%2Fgoogle.com
  # becomes: 
  # http://localhost:3000/comments/http://google.com
  # http://localhost:3000/comments/http%3A%2F%2Flocalhost%3A3001%2Fpage1
  get "/comments/*" do |url|
    content_type :json
    url = CGI.unescape url
    if post = Post.first( url: url )
      post.comments.map{ |c| c.attributes }.to_json
    else
      halt 404, { error: "post not found" }.to_json
    end
  end

  # url = encodeURIComponent(url)
  # comment = {
  #   text: text,
  #   user_id: user_id
  # }
  
  # curl -D "text=comment_text&user_id=12345" http://localhost:3000/comments/http%3A%2F%2Flocalhost%3A3001%2Fpage1

  post "/comments/*" do |url|
    content_type :json
    url = CGI.unescape url
    puts params.inspect
    if post = Post.first( url: url )
      comment = Comment.create({
        text: params[:text],
        user_id: params[:user_id],
      })
      if comment
        { success: "comment inserted" }.to_json
      else
        halt 500, { error: "error creating the comment" }.to_json
      end
    else
      halt 404, { error: "post not found" }.to_json
    end
  end
  
  # curl -X DELETE http://localhost:3000/comments/2
  
  delete "/comments/:id" do
    content_type :json
    comment = Comment.get params[:id]
    if comment
      comment.destroy
      { success: "comment '#{params[:id]}' deleted" }.to_json
    else  
      halt 404, { error: "comment not found" }.to_json
    end
  end

  get "/" do
    haml :index
  end
  
end