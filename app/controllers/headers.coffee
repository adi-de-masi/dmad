Spine = require('spine')

class Headers extends Spine.Controller
  constructor: ->
    super
    @active @render

  render: ->
    @html require('views/header')(@)

  getTitle: ->
    @title
module.exports = Headers
