(function() {
  var FbComments;

  FbComments = (function() {
    var helpers;

    function FbComments(blog) {
      this.blog = blog;
      this.comments = [];
      this.callback = null;
    }

    FbComments.prototype.latest = function(callback) {
      var _this = this;
      if ($(".fb_comments").length !== 0) {
        return $.getJSON("" + fbcomments_host + "/blogs/" + this.blog + "/comments", function(comments) {
          var comment, _i, _len;
          if (comments.length !== 0) {
            for (_i = 0, _len = comments.length; _i < _len; _i++) {
              comment = comments[_i];
              comment = _this.comment_html(comment);
              _this.comments.push(comment);
            }
            return _this.render("comments");
          } else {
            return _this.render("message", "No comments yet.");
          }
        });
      }
    };

    FbComments.prototype.render = function(type, message) {
      switch (type) {
        case "comments":
          $(".fb_comments").html(this.comments.join("\n"));
          break;
        case "message":
          $(".fb_comments").html("<div class='fbc_message'>" + message + "</div>");
          break;
        default:
          console.error("Don't know how to render type: " + type + ". Implement it in fbcomments.coffee");
      }
      if (this.callback) return this.callback();
    };

    helpers = {};

    helpers.format_date = function(date) {
      date = Date.parse(date.substring(0, 19));
      return "" + (date.getDate()) + "/" + (date.getMonth() + 1) + "/" + (date.getFullYear());
    };

    FbComments.prototype.comment_html = function(c) {
      return "    <div class='fbc_comment'>      <fb:profile-pic uid='" + c.user_id + "' linked='true'></fb:profile-pic>      <div class='fbc_from'>          <fb:name uid='" + c.user_id + "' linked='true'></fb:name> commented on <a href='" + c.post.url + "'>" + c.post.name + "</a> (sul blog generale:) " + c.post.blog.label + " <span class='fbc_date'>" + (helpers.format_date(c.created_at)) + "</span>      </div>      <div class='fbc_message'>" + c.text + "</div>      </div>    </div>";
    };

    FbComments.prototype.comment_html_fb = function(comment) {
      return "    <div class='fbc_comment'>      <fb:profile-pic uid='" + comment.from.id + "' linked='true'></fb:profile-pic>      <div class='fbc_from'>" + comment.from.name + "</div>      <div class='fbc_message'>" + comment.message + "</div>    </div>";
    };

    return FbComments;

  })();

  window.FbComments = FbComments;

}).call(this);
