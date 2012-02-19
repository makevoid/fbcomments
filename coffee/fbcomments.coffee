
class FbComments
  
  constructor: (@blog) ->
    # console.log "initializing fbcomments"
    @comments = []
    @callback = null


  latest: (callback) ->  
    if $(".fb_comments").length != 0
      $.getJSON "#{fbcomments_host}/blogs/#{@blog}/comments", (comments) =>
        # console.log "got comments: ", comments
        unless comments.length == 0
          for comment in comments
            comment = this.comment_html comment
            @comments.push comment
          this.render "comments"
        else
          this.render "message", "No comments yet."
  
  render: (type, message) ->
    switch type
      when "comments" 
        $(".fb_comments").html @comments.join("\n")
      when "message"
        $(".fb_comments").html "<div class='fbc_message'>#{message}</div>"
      else
        console.error "Don't know how to render type: #{type}. Implement it in fbcomments.coffee"
    @callback() if @callback
  

  # views:
  
  
  comment_html: (c) ->
    "
    <div class='fbc_comment'>
      <fb:profile-pic uid='#{c.user_id}' linked='true'></fb:profile-pic>
      <div class='fbc_from'>
          <fb:name uid='#{c.user_id}' linked='true'></fb:name> commented on <a href='#{c.post.url}'>#{c.post.name}</a> (sul blog generale:) in TITOLO_BLOG
      </div>
      <div class='fbc_message'>#{c.text}</div>
      </div>
    </div>"
    
  comment_html_fb: (comment) ->
    "
    <div class='fbc_comment'>
      <fb:profile-pic uid='#{comment.from.id}' linked='true'></fb:profile-pic>
      <div class='fbc_from'>#{comment.from.name}</div>
      <div class='fbc_message'>#{comment.message}</div>
    </div>"


window.FbComments = FbComments