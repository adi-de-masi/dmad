Spine = require('spine')

class Menus extends Spine.Controller
  constructor: ->
    super
    @active @render
    
  render: ->
    @html require('views/landing')(@)
module.exports = Menus
