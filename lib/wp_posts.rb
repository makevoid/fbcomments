require 'sequel'

class WPPosts

  def fetch
    Blog.all.map do |blog|
      fetch_wp blog.mysql_attributes
    end.flatten
  end

  def fetch_wp(configs)
    db = Sequel.mysql configs
    db[:wp_posts].where(post_status: "publish", post_parent: 0).select(:id, :guid, :post_name, :post_title).all
  end

end
