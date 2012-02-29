(function() {
  var blog_name, fb_init, g;

  g = window;

  g.config = {};

  config.fbcomments_host = location.host;

  config.fbcomments_host = "web2srv3";

  config.fbcomments_host = "http://" + config.fbcomments_host;

  blog_name = "wp";

  fb_init = function() {
    return FB.init({
      appId: "204625772947506",
      status: true,
      cookie: true,
      xfbml: true
    });
  };

  $(function() {
    var load_fbcomments;
    window.fbAsyncInit = function() {
      $("body").append("<div id='fb-root'></div>");
      return fb_init();
    };
    (function(d) {
      var id, js;
      js = void 0;
      id = "facebook-jssdk";
      if (d.getElementById(id)) return;
      js = d.createElement("script");
      js.id = id;
      js.async = true;
      js.src = "//connect.facebook.net/en_US/all.js";
      return d.getElementsByTagName("head")[0].appendChild(js);
    })(document);
    load_fbcomments = function(callback) {
      var _this = this;
      return $.get("" + config.fbcomments_host + "/fbcomments.js", function(data) {
        eval(data);
        return callback();
      });
    };
    return load_fbcomments(function() {
      var comments, fbcomm;
      fbcomm = new FbComments(blog_name);
      return comments = fbcomm.latest(function() {});
    });
  });

}).call(this);
