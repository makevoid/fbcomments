# App

This is a base sinatra stack that I use daily when building my web apps for projects that are small and don't require a full rails stack, there is some custom code but I hope there's something useful you can use.


### usage:

copy all the files in your folder (including .rvmrc and .gitignore if you want)

run:

    bundle

then:

    rackup

to start the server.


### voidtools:

included by default in the Gemfile there is [voidtools](https://github.com/makevoid/voidtools), a gem with some utilities for datamapper, haml, view helpers and analytics services


### notes: 

analytics

https://www.google.com/analytics/settings/home?scid=ANALYTICS_ID

### textmate js

	function open_in_textmate(path) {
	  app_name = "APP_NAME"
	  url = "txmt://open?url=file://~/Sites/"+app_name+"/"+path
	  document.location = url
	}

	$("#open").click(function(){
	  file = "views/index.haml"
	  open_in_textmate(file)
	})