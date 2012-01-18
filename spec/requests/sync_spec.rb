ENV["RACK_ENV"] = "test"
PATH = File.expand_path "../../../", __FILE__
require "#{PATH}/lib/sync"
DataMapper.auto_migrate!

# fixtures

class FBComm
  def get_full
    { 
      "http://d.makevoid.com:3000/page1" =>
        {"data" =>
          [ {"id" => "10150552265528998_23241159","from" => {"name" => "Francesco Canessa","id" => "1218562195"},"message" => "finally","created_time" => "2011-11-22T20:56:59+0000" } ],
        
  "paging" => {"next" => "https://graph.facebook.com/comments?ids=http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage1,http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage2&limit=25&offset=25&__after_id=10150552265528998_24041249"},
        },
      
      "http://d.makevoid.com:3000/page2" =>
        {"data" =>
          [ {"id" => "10150954104220307_28073690","from" => {"name" => "Francesco Canessa","id" => "1218562195"},"message" => "test","created_time" => "2011-11-22T16:50:53+0000"} ],
              "paging" => {"next" => "https://graph.facebook.com/comments?ids=http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage1,http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage2&limit=25&offset=25&__after_id=10150954104220307_29082478"}
          }
    }
  end
end

describe "Sync" do
  before :all do
    @blog = Blog.create name: "localhost:3001"
    # @post = @blog.posts.create name: "post1", url: "http://localhost:3001/page1"
    # @post2 = @blog.posts.create name: "post2", url: "http://localhost:3001/page2"
  end
  
  
  it "should sync all blogs" do
    Sync.start
    Post.all.count.should == 2
    Comment.all.count.should == 2
  end
  
  
  after :all do
    clear_db
  end
end
