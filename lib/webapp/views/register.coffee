

a href:'/', ->
  img src:'/assets/mapochovalley-home.png', style:'width:360px; height:140px; border:0'
br()
text '
<fb:registration redirect-uri="http://dev.mapochovalley.com/register_callback"
 fb_only="true"
 fields=\'[
   {"name":"name"},
   {"name":"email"}
   ]\' 
 onvalidate="validate"></fb:registration>'