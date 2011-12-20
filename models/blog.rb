class Blog
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 255
  
  has n, :posts
end