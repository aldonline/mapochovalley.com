# helpers
_user = (user) ->
  a href: "/profile/#{user.uid}", title: user.name, ->
    img src: "http://graph.facebook.com/#{user.uid}/picture"

# HTML output
coffeescript -> require('./index').init()

div class:'users', ->
  _user user for user in @users

div class: 'container container-left-index', ->
  ol id:'steps', ->
    li -> 
      if @steps.join
        a href:'/register', -> 'Join'
      else
        span class:'done', -> 'Join'
    li -> a href:'/account', -> 'Customize your Badge'
    li -> a href:'/meetups', -> 'Attend the Meetups'
  
  text '<fb:like-box href="http://www.facebook.com/pages/Mapocho-Valley/112895178787730" width="350" show_faces="false" stream="true" header="false"></fb:like-box>'

div class:'container container-right-index faq', ->
  
  h2 id:'mapocho-header', -> 'About Mapocho Valley'  
  
  p -> 'Mapocho Valley is the Chilean Entrepreneurial Community'
  
  h3 id:'faq-why-so-simple', -> 'Why is this website so simple?'
  p -> """
  We don't want to repeat what you can already find on Facebook or Meetup.com.
  """

  h2 id:'badge-header', -> 'Your Mapocho Badge'

  p -> 'The Mapocho Badge is meant for you to use it when attending a meetup, event
  or conference.'

  h3 id:'faq-attend-meetup', -> 'I am going to a meetup. How do I get my badge?'
  p -> """
    The best way is to print it yourself.
    Otherwise, you can ask the meetup organizer to request the badge
    for every attendee.
    We integrate with Meetup.com so it is easy to request all badges for
    a given meetup.
    """
  
  h2 id:'meetup-header', -> 'Mapocho Meetups'
  
  p -> """Meetups are a great way to meet people."""

  h3 id:'faq-create-meetup', -> 'I want to create my own meetup, what do I do?'
  p -> """
    First, make sure you are not creating a meetup that already exists.
    It is better to join an existing group than create your own meetup.
    We can help you. To create a meetup you need a venue.
    """
  
  h2 id:'points-header', -> 'Mapocho Points'
  
  h3 id:'faq-points', -> 'How do I earn Mapocho Points?'
  p -> """
    You earn Mapocho Points by participating in the community.
    Here are some things you can do:
    """
  table class:'points-table', ->
    tr ->
      th 'Concept'
      th 'Points'
    tr ->
      td -> 'Attend a meetup'
      td -> '1'
    tr ->
      td -> 'Volunteer to help a meetup organizer'
      td -> '3'
    tr ->
      td -> 'Speak in a meetup'
      td -> '5'
    tr ->
      td -> 'Organize a meetup'
      td -> '10'
    tr ->
      td -> 'Speak in a meetup and publish a video recording'
      td -> '10'
    tr ->
      td -> 'Speak in a meetup and publish a video recording in english'
      td -> '12'
    tr ->
      td -> 'Start a startup'
      td -> '20'
    tr ->
      td -> 'Sell your startup for 10 million dolars'
      td -> '100'
  
  p 'You will also get a variable amount of "gift" points each month that you must give to different members'
  
  
  h3 id:'faq-points-why', -> 'Why Should I care?'
  p -> """
    These points correspond roughly to the value you have in the network.
    Also, you will have access to benefits ( free drinks, even tickets, etc )
    """