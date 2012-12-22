require('lib/setup')
Landings = require('controllers/landings')
Beasts = require('controllers/beasts')
Clocks = require('controllers/clocks')

Spine = require('spine')

class App extends Spine.Controller
  $doc = $(document)
  hashRegexp = new RegExp '\#.*'

  constructor: ->
    super
    @setupJquerymobile()
    @landings = new Landings el:@el
    @beasts = new Beasts el:@el
    @clocks = new Clocks el:@el

    @landings.active()

  setupJquerymobile: ->
    $.mobile.changePage.defaults.allowSamePageTransition = true
    $doc.bind "pagebeforechange", (e, jqmData) =>
      @log "pagebeforechange event!"
      if hashRegexp.test jqmData.toPage
        e.preventDefault()
        target = hashRegexp.exec jqmData.toPage
        unless target?.length is 1
          throw new Error "chume noed drus"
        @dispatch target[0], jqmData

  dispatch: (target, jqmData) ->
    @log "going to #{target}"
    if target is "#beast"
      @beasts.active()
    else if target is "#clocks"
      @clocks.active()
      $page = @clocks.el
      $.mobile.changePage( $page, jqmData.options)
    else if target is "#landing"
      @landings.active()
      #@el.trigger "create"


module.exports = App
    
