Spine = require('spine')

class Headers extends Spine.Controller
  constructor: ->
    super
    @active @render

  render: ->
    @el.empty()
    @html require('views/header')(@)

  getTitle: ->
    @title
module.exports = Headers
