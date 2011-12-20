class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 255
  property :url, String, length: 255
  property :comments_count, Integer, default: 0 
  
  has n, :comments
  belongs_to :blog
end