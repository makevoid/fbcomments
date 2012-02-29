class Blog
  include DataMapper::Resource

  property :id, Serial
  property :name, String, length: 255, index: true
  property :label, String, length: 255, index: true

  property :host, String
  property :user, String
  property :password, String
  property :database, String

  has n, :posts

  def mysql_attributes
    { name: name, host: host, user: user, password: password, database: database }
  end

end