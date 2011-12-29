path = File.expand_path "../../", __FILE__
PATH = path

require "#{PATH}/config/env"
require 'net/https'

class Hash
	def symbolize_keys
		replace(inject({}) { |h,(k,v)| h[k.to_sym] = v; h })
	end
end

class FBComm
  URL = "https://graph.facebook.com/comments/?ids=%s"
  
  def initialize(blog)
    @blog = blog
  end
  
  def fetch
    urls = "http://d.makevoid.com:3000/page1,http://d.makevoid.com:3000/page2"
    resp = get(URL % urls)
    datas = JSON.parse(resp.body)
    datas.map do |post, comments|
      # puts post
      comments = comments["data"]
      comments.map do |comment|
        comment = comment.symbolize_keys
        comment[:created_time] = Time.parse comment[:created_time]
        insert_comment_if_new comment, post
      end
    end
    # {"http://d.makevoid.com:3000/page1"=>{"data"=>[{"id"=>"10150552265528998_23241159", "from"=>{"name"=>"Francesco Canessa", "id"=>"1218562195"}, "message"=>"finally", "created_time"=>"2011-11-22T20:56:59+0000"}, {"id"=>"10150552265528998_23689606", "from"=>{"name"=>"Francesco Canessa", 
    
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
  
  def get(url)
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new uri.request_uri
    http.request req
  end
end


Blog.all.each do |blog|
  FBComm.new(blog).fetch
end