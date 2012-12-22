Spine = require('spine')

class Landings extends Spine.Controller
  constructor: ->
    super
    @active @render

  active: ->
    @html require('views/landing')(@)
    
module.exports = Landings
