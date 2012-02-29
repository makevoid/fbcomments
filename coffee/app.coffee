g = window

# config:
g.config = {}
config.fbcomments_host = location.host
config.fbcomments_host = "web2srv3"
config.fbcomments_host = "http://#{config.fbcomments_host}"

blog_name = "wp"
# 


fb_init = ->
  FB.init
    appId: "204625772947506"
    status: true
    cookie: true
    xfbml: true


$ ->

  window.fbAsyncInit = ->
    $("body").append("<div id='fb-root'></div>")
    fb_init()
        
    # FB.getLoginStatus (response) ->  
    #   if response.status == "connected"
    #     $(".nav_right").append "Logged in as user: #{response.session.uid}"
    #   else
    #     $(".fb-login-button").fadeIn()
    
  ((d) ->
    js = undefined
    id = "facebook-jssdk"
    return  if d.getElementById(id)
    js = d.createElement("script")
    js.id = id
    js.async = true
    js.src = "//connect.facebook.net/en_US/all.js"
    d.getElementsByTagName("head")[0].appendChild js
  ) document  
  
  load_fbcomments = (callback) ->
    $.get "#{config.fbcomments_host}/fbcomments.js", (data) =>
      eval data
      callback()


  load_fbcomments ->
    fbcomm = new FbComments blog_name
    comments = fbcomm.latest  ->
      # console.log "latest done"
      # console.log fbcomm
    # fb_init()    
  # fb_init()
  # fbcomm.fetch_from_fb()
  

    
