require "spec_helper"

feature "FBComments", js: true do

  context "basic" do
    it "displays the home page" do
      visit "/"
      should_render
    end
  end

  context "without comments" do
    it "displays a message" do
      visit "/"
      page.find(".fbc_message").should have_content("No comments yet")
    end
  end

  context "with comments" do

    before :all do
      @blog = Blog.create name: "localhost:3001"
      @post = @blog.posts.create name: "post1", url: "http://localhost:3001/post1"
      @comment = @post.comments.create text: "comment1"
    end

    describe "root page" do

      before :each do
        visit "/"
      end

      it "displays a list of comments" do
        page.find(".fb_comments").should have_content("comment1")
      end

    end

  end

  after :all do
    clear_db
  end

end