# FBCommments

### get Facebook comments counts from Wordpress posts

- configure fbcomments

   TODO: spec and document the process
   
- setup cronjob for sync

    1 * * * * RACK_ENV=production /usr/bin/ruby /www/fbcomments/current/lib/sync.rb

### Crontab

as www-data:

    cd /www/fbcomments/current/; RACK_ENV=production bundle exec ruby lib/sync.rb start

### Code to insert:

In header.php, before the end of the <head> tag
  
    
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>

then open a script tag

    <script type="text/javascript"></script>

and paste the content of this file (found in this repo) into the script tag: 
    
    /public/js/app.js


In the post page (single.php) 

    <div class="fb-comments" data-href="<?php echo  "http://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'] ?>" data-num-posts="4"></div>
    <?php // comments_template( '', true ); ?>

In sidebar partial (sidebar.php) or in home page add the blog aggregated comments:

    <div class="comments"><div class="fb_comments"></div></div>
