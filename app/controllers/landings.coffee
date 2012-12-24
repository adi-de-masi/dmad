Spine = require('spine')
Headers = require('controllers/headers')
Menus = require('controllers/menus')

class Landings extends Spine.Controller
  elements:
    "#header": "header",
    "#content": "content",

  events:
    "click .front": "toggleCard",
    "click .back": "toggleCard"

  toggleCard: ->
    @el.find('.front').toggle()
    @el.find('.back').toggle()

  constructor: ->
    super
    @headers = new Headers el:@header, title: "Merry Christmas Lucy!"
    @menus = new Menus el:@content
    @active @render

  render: ->
    @headers.active()
    @menus.active()
    $card = @el.find('#card')

    
module.exports = Landings
