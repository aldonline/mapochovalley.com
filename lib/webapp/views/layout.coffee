
# helpers
_require = (module) ->
  script -> "exports = require('#{module}')"
  script src:"/js/#{module}.js"
_metaprop = (p, c) -> (meta property:p, content:c) if c?
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
    link rel: 'stylesheet', href: '/css/styles.css'
    link rel: 'stylesheet', href: '/css/smoothness/jquery-ui-1.8.7.custom.css'
    ###
    script src: 'http://widgets.twimg.com/j/2/widget.js'
    script src: '/js/jquery-1.4.4.min.js'
    script src: '/js/jquery.cookie.js'
    script src: '/js/jquery-ui-1.8.7.custom.min.js'
    script src: '/js/jquery.validate.min.js'
    script src: '/js/jquery.datalink.js'
    script src: '/___minirpc.js'
    script src: '/__fbx.js'
    script -> 'var __modules={}, exports, require=function(id){var m=__modules;return m[id]?m[id]:(m[id]={})}'
    _require r for r in @requires
    ###
  body ->
    if @show_fb_login_button
      text '<fb:login-button id="fb-login-button"
              autologoutlink="true"
              registration-url="http://dev.mapochovalley.com/register" 
              fb-only="true"></fb:login-button>'
    div id:'flw'
    div -> @body
    div id:'fb-root'