require 'sequel'

class WPPosts

  def initialize(blog)
    @blog = blog
  end

  def fetch
    fetch_wp @blog.mysql_attributes
  end

  def fetch_wp(configs)
    db = Sequel.mysql configs.merge(encoding: 'utf8')
    db[:wp_posts].where(post_status: "publish", post_parent: 0).select(:id, :guid, :post_name, :post_title).all
  end

end
