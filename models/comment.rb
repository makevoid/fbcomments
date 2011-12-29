class Comment
  include DataMapper::Resource
  
  property :id, Serial
  property :fb_id, String
  property :text, Text
  property :user_id, Integer
  property :created_at, DateTime
  property :imported_at, DateTime
  # property :username, String, length: 255
  # property :userpic_url, String, length: 255
  
  belongs_to :post
  
  before :create do
    self.imported_at = Time.now
  end
  
  before :create do
    self.post.comments_count += 1
    self.post.save
  end
  
  before :destroy do
    self.post.comments_count -= 1
    self.post.save
  end
   
  
  def public_attributes
    attributes.merge( 
      post: { 
        name: post.name,
        url: post.name,
        comments_count: post.comments_count 
      }
    )
  end
end