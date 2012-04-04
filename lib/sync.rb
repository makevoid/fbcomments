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
require_relative "fb_comm"

class Sync

  CUSTOM_PERMALINK = Proc.new do |blog, post|
    "http://#{blog.name}/#{post[:post_name]}.html" # /%postname%.html
  end
  # CUSTOM_PERMALINK = nil # to use default permalink

  def self.start
    Blog.all.each do |blog|
      new(blog).start
    end
  end

  def initialize(blog)
    @blog = blog
  end

  def start
    create_posts
    FBComm.new(@blog).fetch
  end

  private

  def create_posts
    wpp = WPPosts.new(@blog)
    posts = wpp.fetch

    posts.each do |post|
      url = get_post_url(@blog, post)
      exists = @blog.posts.first url: url
      @blog.posts.create( id_wp: post[:id], url: url, name: post[:post_title] ) unless exists
    end
  end

  def get_post_url(blog, post)
    CUSTOM_PERMALINK.call(blog, post) || post[:guid]
  end

end

if ARGV[0] && ARGV[0].strip == "start"
  Sync.start
end
