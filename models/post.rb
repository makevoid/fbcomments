class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 255
  property :url, String, length: 255
  property :comments_count, Integer, default: 0, index: true 
  property :id_wp, Integer, index: true
  
  has n, :comments
  belongs_to :blog
end