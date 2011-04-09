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
    li -> 'Join'
    li -> 'Customize your Badge'
    li -> 'Attend the Meetups'

div class:'container container-right-index faq', ->
  
  h2 'About Mapocho Valley'  
  
  p -> 'Mapocho Valley is the Chilean Entrepreneurial Community'
  
  h3 id:'faq-why-so-simple', -> 'Why is this website so simple?'
  p -> """
  We don't want to repeat what you can already find on Facebook.
  We believe Facebook is an excellent social platform.
  You won't meet someone by talking to him 2 hours.
  Facebook provides the perfect solution to keep in touch.
  """
  
  h2 'Meetups'
  
  p -> """Meetups are a great way to meet people."""

  h3 id:'faq-attend-meetup', -> 'I am going to a meetup. How do I get my badge?'
  p -> """
    The best way is to print it yourself.
    Otherwise, you can ask the meetup organizer to request the badge
    for every attendee.
    We integrate with Meetup.com so it is easy to request all badges for
    a given meetup.
    """

  h3 id:'faq-create-meetup', -> 'I want to create my own meetup, what do I do?'
  p -> """
    First, make sure you are not creating a meetup that already exists.
    It is better to join an existing group than create your own meetup.
    We can help you. To create a meetup you need a venue.
    """  
  
  
  h2 'Stars'
  
  h3 id:'faq-stars', -> 'How do I earn stars?'
  p -> """
    You get 1/4th of a star for every meetup you attend,
    and 1 star for every time you speak.
    Click here to see more ways to earn stars
    """

  h3 id:'faq-stars', -> 'Why would I care?'
  p -> """
    You get 1/4th of a star for every meetup you attend,
    and 1 star for every time you speak.
    Click here to see more ways to earn stars
    """

