Spine = require('spine')

class Landings extends Spine.Controller
  constructor: ->
    super
    @active @render

  active: ->
    @append require('views/landing')(@)
    
module.exports = Landings
