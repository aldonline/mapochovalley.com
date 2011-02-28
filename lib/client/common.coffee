
$ ->
  console.log 'common init()'

render_twitter_widget = (profile) ->
  tw = new TWTR.Widget
    version: 2
    type: if profile? then 'profile' else 'search'
    search: '#mapochovalley' if not profile?
    interval: 6000
    title: ''
    subject: if profile? then '@' + profile else '#mapochovalley'
    width: 250
    height: 300
    theme:
      shell:
        background: '#cccccc'
        color: '#ffffff'
      tweets:
        background: '#ffffff'
        color: '#444444'
        links: '#1985b5'
    features:
      scrollbar: false
      loop: true
      live: true
      hashtags: true
      timestamp: true
      avatars: true
      toptweets: true
      behavior: 'default'
  tw.render()
  tw.setUser profile if profile?
  tw.start()

exports.render_twitter_widget = render_twitter_widget