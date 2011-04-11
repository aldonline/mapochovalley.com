
# helpers
_metaprop = (p, c) -> (meta property:p, content:c) if c?
_s = (src) -> script src: src
_c = (href) -> link rel: 'stylesheet', href: href

# start HTML doc
doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    # start Facebook Open Graph tags for "share" plugin compatibility
    _metaprop 'og:title', @og_title
    _metaprop 'og:description', @og_description
    _metaprop 'og:image', @og_image
    # end Facebook Open Graph tags for "share" plugin compatibility
    title ( if @title? then @title + ' @ ' else '' ) + @strings.title
    meta(name: 'description', content: @description) if @description?
    _c '/css/styles.css'
    _c 'http://fonts.googleapis.com/css?family=Permanent+Marker'
    _c 'http://fonts.googleapis.com/css?family=Droid+Serif:regular,bold'
    _c '/css/smoothness/jquery-ui-1.8.7.custom.css'
    _s 'http://widgets.twimg.com/j/2/widget.js'
    _s '/js-lib/jquery-1.4.4.min.js'
    _s '/js-lib/jquery.cookie.js'
    _s '/js-lib/jquery-ui-1.8.7.custom.min.js'
    _s '/js-lib/jquery.validate.min.js'
    _s '/js-lib/jquery.datalink.js'
    _s '/___minirpc.js'
    _s '/__fbx.js'
    _s '/client.js'
    coffeescript -> require('./common').init()
  body ->
  
    div id:'main-container', ->
  
      # ------ navigation ( top bar )
      section -> 
        div class:'nav', ->
          ul ->
            if @nav.home
              li -> a href:"/", -> "Home"
            if @nav.account
              li -> a href:"/account", -> "Edit Account"
            if @nav.profile
              li -> a href:"/profile", -> "View Profile"
            if @nav.login
              #li -> 
              #  a href:'/profile', ->
              #    text '<fb:profile-pic uid="loggedinuser" linked="false"></fb:profile-pic>'
              li ->
                div style:'width:180px; display:inline-block', ->
                  text '<fb:login-button id="fb-login-button"
                          autologoutlink="true"
                          registration-url="'+@config.url+'/register"
                          fb-only="true"></fb:login-button>'
    
      # ------ content
      section ->
        div class:'main-container', ->
          center ->
            a href:'/', ->
              img 
                src:'/assets/mapochovalley-home.png'
                width:360
                height:140
                border:0
          @body