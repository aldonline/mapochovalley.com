strings = require './strings'

try
  localconfig = require '../localconfig'
catch error
  # should we use stderr?
  console.log '''

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
    url: "http://localhost"

  Replace placeholder values by real Facebook App credentials.
  This file is .gitignored so it will remain local to your machine
  For more information see: https://github.com/aldonline/mapochovalley.com

  ########################################  
  ########################################
  '''
  process.exit 1

module.exports = localconfig.get_config()