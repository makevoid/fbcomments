class Comment
  include DataMapper::Resource
  
  property :id, Serial
  property :text, Text
  property :created_at, DateTime
  property :user_id, Integer
  # property :username, String, length: 255
  # property :userpic_url, String, length: 255
  
  before :create do
    self.created_at = Time.now
  end
  
  before :create do
    self.post.comments_count += 1
    self.post.save
  end
  
  before :destroy do
    self.post.comments_count -= 1
    self.post.save
  end
  
  belongs_to :post  
end