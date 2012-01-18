require 'spec_helper'

describe "Comments" do

  before :all do
    @blog = Blog.create name: "localhost:3001"
    @post = @blog.posts.create name: "post1", url: "http://localhost:3001/post1"
    @comment = @post.comments.create text: "comment1"
  end


  it "GET /posts/:post_id/comments" do
    post_id = "http%3A%2F%2Flocalhost%3A3001%2Fpost1"
    # post_id = CGI.escape @post.url
    get "/posts/#{post_id}/comments"
    comment = json_response.first.symbolize_keys
    comment[:id].should == 1
    comment[:text].should == "comment1"
  end
  
  it "GET /blogs/:blog_id/comments" do
    get "/blogs/localhost:3001/comments"
    comment = json_response.first.symbolize_keys
    comment[:id].should == 1
    comment[:text].should == "comment1"
  end

end