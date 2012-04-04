class FBComm
  URL = "https://graph.facebook.com/comments/?ids=%s&limit=1000000"

  def initialize(blog)
    @blog = blog
  end

  def fetch
    datas = get_full
    datas.map do |post, comments|
      # puts post
      comments = comments["data"]

      puts "-"*80
      p comments

      comments.map do |comment|
        comment = comment.symbolize_keys
        comment[:created_time] = Time.parse comment[:created_time]
        insert_comment_if_new comment, post
      end if comments
    end
  end

  private

  def base_url
    URL % posts_urls
  end

  def posts_urls
    @blog.posts.map{ |post| post.url }.join(",")
  end

  def insert_comment_if_new(comment, post_url)
    comm = Comment.first(fb_id: comment[:id])
    unless comm
      post = @blog.posts.first(url: post_url)
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
    puts "url: #{base_url}"
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