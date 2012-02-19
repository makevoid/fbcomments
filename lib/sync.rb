path = File.expand_path "../../", __FILE__
PATH = path

require "#{PATH}/config/env"
require 'net/https'



class Hash
	def symbolize_keys
		replace(inject({}) { |h,(k,v)| h[k.to_sym] = v; h })
	end
end

require_relative 'wp_posts'

class FBComm
  URL = "https://graph.facebook.com/comments/?ids=%s"
  
  def initialize(blog)
    @blog = blog
  end
  
  def base_url  
    URL % "http://d.makevoid.com:3000/page1,http://d.makevoid.com:3000/page2"
  end
  
  def fetch
    datas = get_full 
    datas.map do |post, comments|
      # puts post
      comments = comments["data"]
      comments.map do |comment|
        comment = comment.symbolize_keys
        comment[:created_time] = Time.parse comment[:created_time]
        insert_comment_if_new comment, post
      end
    end    
  end
  
  private
  
  def insert_comment_if_new(comment, post_url)
    comm = Comment.first(fb_id: comment[:id])
    unless comm
      post = Post.first(url: post_url)
      unless post
        post = @blog.posts.create( url: post_url ) 
      end
      
      post.comments.create(
        text: comment[:message],
        user_id: comment[:from]["id"],
        fb_id: comment[:id],
        created_at: comment[:created_time],
      )    
    end
  end
  
  def get_full
    resp = get(base_url)
    JSON.parse resp.body
  end
  
  def get(url)
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new uri.request_uri
    http.request req
  end
end


class Sync
  
  def self.start
    create_posts
    
    Blog.all.each do |blog|
      FBComm.new(blog).fetch
    end
  end
  
  def self.create_posts
    wpp = WPPosts.new
    posts = wpp.fetch
    
    posts.each do |post|
      exists = Post.first url: post[:guid]
      Post.create( id_wp: post[:id] ) unless exists
    end
  end
  
end

if ARGV[0] && ARGV[0].strip == "start"
  Sync.start
end
