path = File.expand_path "../../../", __FILE__
require "#{path}/lib/wp_posts"

require "spec_helper"
# --- or ---
# ENV["RACK_ENV"] = "test"
# require "#{path}/config/env"
# DataMapper.auto_migrate!

describe WPPosts do

  before :all do
    blogs = [
      {
        name: "wp",
        host: "127.0.0.1",
        user: "root",
        password: "",
        database: "wp_blog",
      }
    ]

    blogs.each do |blog|
      blog = Blog.create blog
      post = blog.posts.create name: "post1", url: "http://#{blog[:name]}/page1"
      comment = post.comments.create text: "commment", user_id: 1218562195
      comment = post.comments.create text: "commment 2", user_id: 1218562195
    end

  end

  it "should fetch the posts" do
    wpp = WPPosts.new Blog.first
    wpp.fetch.should include(id: 1, guid: "http://wp/?p=1", post_name: "hello-world")
    # p MYSQL_FIXTURE
  end

  after :all do
    clear_db if defined?(clear_db)
  end

end

# TODO:


# launch fixture before the test

# CREATE DATABASE IF NOT EXISTS #{BLOGS.first[:name]};

MYSQL_FIXTURE = "

DROP TABLE IF EXISTS `wp_posts`;

CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(20) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` text NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `wp_posts` WRITE;
/*!40000 ALTER TABLE `wp_posts` DISABLE KEYS */;

INSERT INTO `wp_posts` (`ID`, `post_author`, `post_date`, `post_date_gmt`, `post_content`, `post_title`, `post_excerpt`, `post_status`, `comment_status`, `ping_status`, `post_password`, `post_name`, `to_ping`, `pinged`, `post_modified`, `post_modified_gmt`, `post_content_filtered`, `post_parent`, `guid`, `menu_order`, `post_type`, `post_mime_type`, `comment_count`)
VALUES
	(1,1,'2012-01-18 22:52:19','2012-01-18 22:52:19','Welcome to WordPress. This is your first post. Edit or delete it, then start blogging!','Hello world!','','publish','open','open','','hello-world','','','2012-01-18 22:52:19','2012-01-18 22:52:19','',0,'http://wp/?p=1',0,'post','',2),
	(2,1,'2012-01-18 22:52:19','2012-01-18 22:52:19','This is an example page. It\'s different from a blog post because it will stay in one place and will show up in your site navigation (in most themes). Most people start with an About page that introduces them to potential site visitors. It might say something like this:\n\n<blockquote>Hi there! I\'m a bike messenger by day, aspiring actor by night, and this is my blog. I live in Los Angeles, have a great dog named Jack, and I like pi&#241;a coladas. (And gettin\' caught in the rain.)</blockquote>\n\n...or something like this:\n\n<blockquote>The XYZ Doohickey Company was founded in 1971, and has been providing quality doohickies to the public ever since. Located in Gotham City, XYZ employs over 2,000 people and does all kinds of awesome things for the Gotham community.</blockquote>\n\nAs a new WordPress user, you should go to <a href=\"http://wp/wp-admin/\">your dashboard</a> to delete this page and create new pages for your content. Have fun!','Sample Page','','publish','open','open','','sample-page','','','2012-01-18 22:52:19','2012-01-18 22:52:19','',0,'http://wp/?page_id=2',0,'page','',0),
	(3,1,'2012-01-18 22:52:37','0000-00-00 00:00:00','','Auto Draft','','auto-draft','open','open','','','','','2012-01-18 22:52:37','0000-00-00 00:00:00','',0,'http://wp/?p=3',0,'post','',0),
	(4,1,'2012-01-18 22:53:03','2012-01-18 22:53:03','test','test post #1','','publish','open','open','','test-post-1','','','2012-01-18 22:53:03','2012-01-18 22:53:03','',0,'http://wp/?p=4',0,'post','',1),
	(5,1,'2012-01-18 22:53:00','2012-01-18 22:53:00','','test post #1','','inherit','open','open','','4-revision','','','2012-01-18 22:53:00','2012-01-18 22:53:00','',4,'http://wp/?p=5',0,'revision','',0),
	(6,1,'2012-01-18 22:53:17','2012-01-18 22:53:17','blablabal','post #3','','publish','open','open','','post-3','','','2012-01-18 22:53:17','2012-01-18 22:53:17','',0,'http://wp/?p=6',0,'post','',2),
	(7,1,'2012-01-18 22:53:14','2012-01-18 22:53:14','','post #3','','inherit','open','open','','6-revision','','','2012-01-18 22:53:14','2012-01-18 22:53:14','',6,'http://wp/?p=7',0,'revision','',0),
	(8,1,'2012-01-18 22:54:18','2012-01-18 22:54:18','blablabal','post #3','','inherit','open','open','','6-autosave','','','2012-01-18 22:54:18','2012-01-18 22:54:18','',6,'http://wp/?p=8',0,'revision','',0);

/*!40000 ALTER TABLE `wp_posts` ENABLE KEYS */;
UNLOCK TABLES;"