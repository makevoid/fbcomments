require "spec_helper"

BLOGS = [
  {
    name: "wp",
    label: "WordpressBlog",
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "wp_blog",
  }
]

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
      @blog = BLOGS.first
      blog = Blog.create @blog
      @post = blog.posts.create name: "post1", url: "http://#{@blog[:name]}/page1"
      @time = Time.now
      @comment = @post.comments.create text: "comment1", user_id: 1218562195, created_at: @time
    end

    describe "root page" do

      before :each do
        visit "/"
      end

      it "displays a list of comments" do
        page.find(".fb_comments").should have_content("comment1")
      end

      it "displays all comments field" do
        page.find(".fb_comments").should have_content("commented on post1 5/4/2012 comment1")
        page.find(".fb_comments").should have_content("#{@time.day}/#{@time.month}/#{@time.year}")
      end
    end

  end

  after :all do
    clear_db
  end

end