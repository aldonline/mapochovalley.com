x = exports

x.description = 'Mapocho Valley is an entry point to the emerging high tech community of Santiago Chile'
x.title = 'Mapocho Valley'

x.err_localconfig_is_missing = '''

########################################  
########################################

ERROR: Missing Local Configuration File.
---------------------------------------
Please create a file named localconfig.coffee and store it in the root 
of this project, alongside the start.sh script you just executed.
Inside this file, copy paste the following 4 lines of code:

exports.get_config = ->
  app_id: "111111111111"
  app_secret: "111111111111111"
  domain: "localhost"

Replace placeholder values by real Facebook App credentials.
This file is .gitignored so it will remain local to your machine
For more information see: https://github.com/aldonline/mapochovalley.com

########################################  
########################################
'''