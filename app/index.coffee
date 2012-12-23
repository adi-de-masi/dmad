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
    $.mobile.defaultPageTransition = "none"

    $doc.bind "pagebeforechange", (e, jqmData) =>
      @log "pagebeforechange event!"
      if typeof jqmData.toPage is "string"
        # an explicit hash change event
        if hashRegexp.test jqmData.toPage
          target = @extractTarget(jqmData.toPage)
          @dispatch target, jqmData
          e.preventDefault()
        # By default, we go to the landing page
        else
          @dispatch "#landing", jqmData
          e.preventDefault()
      # url containing a hash was entered by hand
      else if hashRegexp.test(jqmData?.toPage?.context?.URL) and jqmData.options?.redirected is undefined
          target = @extractTarget jqmData.toPage.context.URL
          jqmData.toPage = target
          jqmData.options.redirected = true
          @dispatch target, jqmData
          e.preventDefault()
      else
        @log "siechnomal"


  extractTarget: (urlString) ->
    result = hashRegexp.exec urlString
    if result?.length is 1
      return result[0]
    else if result is null
      return "#landing"
    else if result?.length > 1
      throw new Error "chume noed drus"


  dispatch: (target, jqmData) ->
    url = $.mobile.path.parseUrl( jqmData.toPage )
    jqmData.options.dataUrl = url.href
    @log "going to #{url.href}"
    if target is "#beast"
      @changePage @beasts, jqmData
    else if target is "#clock"
      @changePage @clocks, jqmData
    else if target is "#landing"
      @changePage @landings, jqmData

    @el.trigger "create"

  changePage: (controller, jqmData) ->
    controller.active()
    $page = controller.el
    $.mobile.changePage( $page, jqmData.options )


module.exports = App
    
