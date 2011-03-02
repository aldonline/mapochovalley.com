The MapochoValley.com Web App
=============================================

NOTES:

  * THE FOLLOWING INSTRUCTIONS DON'T WORK YET. BE PATIENT
  * THIS IS NOT THE CURRENT SITE AT MAPOCHOVALLEY.COM. THIS IS A NEWER VERSION

Getting Started
--------------------

### Setting up the MV Web App for local development

Make sure you have [Node](http://nodejs.org/) >= v0.4 and the latest [NPM](https://github.com/isaacs/npm).
You can just copy paste the following scripts, but I highly encourage you to read through to get an idea of how this works:

By convention, we keep sources in /usr/src

    sudo mkdir -p /usr/src
    cd /usr/src

Clone repo. Note: if you plan to develop and contribute back, use your own Git fork instead

    git clone git://github.com/aldonline/mapochovalley.com.git

Install the package using NPM.
Since the project is packaged as an NPM module, issuing the following command will automatically fetch all dependencies. It will take a while as some deps need to build.

    cd mapochovalley.com
    sudo npm link .

" What? Is this a library/module? I thought this was a Web application. Why use NPM?"

Right. The short answer is: We are using NPM because it makes it easy to handle our apps dependencies, but we are not exporting anything.

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

[Aldo] We should provide some test data. But that's not trivial as since everyone is using a different Facebook App, it won't work for everyone. The other option is to share a Facebook App amongst ourselves. But in the open? Hmm...


