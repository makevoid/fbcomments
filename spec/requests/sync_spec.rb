require "spec_helper"
# ENV["RACK_ENV"] = "test"
# PATH = File.expand_path "../../../", __FILE__
require "#{PATH}/lib/sync"
# DataMapper.auto_migrate!


# fixtures

class FBComm
  def get_full
    JSON.parse '{
       "http://d.makevoid.com:3000/page1": {
          "comments": {
             "data": [
                {
                   "id": "10150552265528998_23241159",
                   "from": {
                      "name": "Francesco Canessa",
                      "id": "1218562195"
                   },
                   "message": "finally",
                   "created_time": "2011-11-22T20:56:59+0000"
                },
                {
                   "id": "10150552265528998_23689606",
                   "from": {
                      "name": "Francesco Canessa",
                      "id": "1218562195"
                   },
                   "message": "test1",
                   "created_time": "2011-12-12T19:26:58+0000"
                }
             ],
             "paging": {
                "next": "https://graph.facebook.com/comments?ids=http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage1,http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage2&limit=2&offset=2&__after_id=10150552265528998_23689606"
             }
          }
       },
       "http://d.makevoid.com:3000/page2": {
          "comments": {
             "data": [
                {
                   "id": "10150954104220307_28073690",
                   "from": {
                      "name": "Francesco Canessa",
                      "id": "1218562195"
                   },
                   "message": "test",
                   "created_time": "2011-11-22T16:50:53+0000"
                },
                {
                   "id": "10150954104220307_28073708",
                   "from": {
                      "name": "Francesco Canessa",
                      "id": "1218562195"
                   },
                   "message": "test2",
                   "created_time": "2011-11-22T16:51:10+0000"
                }
             ],
             "paging": {
                "next": "https://graph.facebook.com/comments?ids=http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage1,http\u00253A\u00252F\u00252Fd.makevoid.com\u00253A3000\u00252Fpage2&limit=2&offset=2&__after_id=10150954104220307_28073708"
             }
          }
       }
    }'
  end
end

describe "Sync" do
  before :all do
    blog = {
      name: "wp",
      host: "127.0.0.1",
      user: "root",
      password: "",
      database: "wp_blog",
    }

    @blog = Blog.create blog
    # @post = @blog.posts.create name: "post1", url: "http://localhost:3001/page1"
    # @post2 = @blog.posts.create name: "post2", url: "http://localhost:3001/page2"
  end


  it "should sync all blogs" do
    Sync.start
    Post.all.count.should == 6
    Comment.all.count.should == 4
  end

  describe "FBComm" do
    context "#posts_urls" do
      it "should list posts" do
        fbcomm = FBComm.new(@blog)
        fbcomm.send(:posts_urls).should == "http://wp/hello-world.html,http://wp/sample-page.html,http://wp/test-post-1.html,http://wp/post-3.html,http://d.makevoid.com:3000/page1,http://d.makevoid.com:3000/page2"
      end
    end
  end

  after :all do
    clear_db if defined?(clear_db)
  end
end

