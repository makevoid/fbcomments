require "spec_helper"

feature "FBComments" do
  
  before :all do
    @blog = Blog.create name: "localhost:3001"
    @post = @blog.posts.create name: "post1", url: "http://localhost:3001/post1"
    @comment = @post.comments.create text: "comment1"
  end
  
  describe "root page" do
    
    before :each do      
      visit "/"
    end
    
    it "displays the home page" do
      should_render
    end
  
    it "displays a list of comments" do
      page.should have_content("comment1")
    end
  
  end

  
end