The MapochoValley.com Web App
=============================================

NOTES:

  * THIS IS NOT THE CURRENT SITE AT MAPOCHOVALLEY.COM. THIS IS A NEWER VERSION


Development Guidelines
-----------------------------------

  * Add bugs, ideas, feature requests, etc to the [Issues Section of This GitHub Project](https://github.com/aldonline/mapochovalley.com/issues)
  * When "accepting" an issue, tag it with your username preceded by an underscore. For example, Aldo uses the tag: _aldonline

Setting up the MV Web App for local development
------------------------------------------------------------------------

### Dependencies

  * [Node](http://nodejs.org/) >= v0.4.1 (**So far, tested and working with v0.4.1. We had problems related to modules express and connect using v0.4.2**)
  * The latest [NPM](https://github.com/isaacs/npm)
  * [Mongo DB](http://www.mongodb.org/) >= 1.6.5

### Get Source

By convention, we keep sources in /usr/src

    mkdir -p /usr/src
    cd /usr/src

Clone repo. Note: if you plan to develop and contribute back, use your own Git fork instead

    git clone git://github.com/aldonline/mapochovalley.com.git

### Install the package using NPM.

Since the project is packaged as an NPM module, issuing the following command will automatically fetch all dependencies. It will take a while as some deps need to build.

    cd mapochovalley.com
    npm link .

We are using NPM because it makes it easy to handle our apps dependencies, but we are not exporting anything. You won't find youself doing require('mapochovalley.com'). This is a valid use case for NPM.

### Some Manual Fixes

Node.js is quite new, so you can't expect things to be 100% smooth. Here are some things you will have to solve manually

#### Coffeekup Is not Correctly Packaged

coffeekup v0.2.2 does not conform to the new NPM export spec.
you will need to run the following in order to get and use a "patched" version of this package.
Hopefully Maurice will fix this soon and we can default back to the normal workflow.

    mkdir -p /usr/src
    cd /usr/src
    git clone git@github.com:aldonline/coffeekup.git
    cd coffeekup
    npm link .

#### Express and Connect Incompatibility

express has not (yet) caught up with connect. In particular, it has been reported that connect > 1 [will break express](http://stackoverflow.com/questions/5161828/express-framework-giving-a-very-strange-error). Make sure to install the following specific version of connect:

    npm install connect@0.5.10

#### Install and Run

Everything is ready. You can now try to run the app. Use sudo as the app will try to listen on port 80 by default.

    sudo sh start.sh

Oops. I lied ;)
Things are not ready. You will get a nice error message in the console telling you to do some more stuff...

    ERROR: Missing Local Configuration File.
    Please create a file named localconfig.coffee and store it in the root 
    of this project, alongside the start.sh script you just executed.
    Inside this file, copy paste the following lines:
    
    exports.get_config = ->
      app_id: '111111111111'
      app_secret: '111111111111111'
      domain: 'localhost'
    
    Replace values by real Facebook App credentials.

You can create a Facebook App by going to the [Facebook "Developer" Application](http://www.facebook.com/developers/) .

I prefer to call my app 'Localhost', set the URL to 'http://localhost/' and the domain to 'localhost'

Notice that localconfig.coffee is .gitignored, so don't worry about sharing your credentials.

Now, start the app once more:

    sudo sh start.sh

Open your browser and point to [http://localhost/](http://localhost/)

Voila!

You will see the app, but there are no users.

In order to get some users, do the following:

  * Add yourself as user
  * Add your mom/dad/girlfriend ;)
  * Create test users ( TODO: explain )
  
#### Troubleshooting

If you installed as non-root user, and have problems like to "Module not found" exception, that's because the module search paths does not points to the correct module install dir. To know the paths that node is using execute

    $ node
    > require.paths
    [ '/Users/:username/.node_modules', '/Users/:username/.node_libraries', '...' ]
    
if you have something like that, then a solution is to create a symlink target = $HOME/.node_modules to the correct path where modules are installed. How to know where the hell is that path?, execute

    $ nmp config list
    
and take a look at the root property, in my laptop (mac OSX) is at "/usr/local/lib/node", so i did

    $ ln -s /usr/local/lib/node $HOME/.node_modules

[Aldo] We should provide some test data. But that's not trivial as since everyone is using a different Facebook App, it won't work for everyone. The other option is to share a Facebook App amongst ourselves. But in the open? Hmm...












