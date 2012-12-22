Spine = require('spine')
Headers = require('controllers/headers')
Menus = require('controllers/menus')

class Landings extends Spine.Controller
  elements:
    "#header": "header",
    "#content": "content"

  constructor: ->
    super
    @headers = new Headers el:@header, title: "Welcome to the world"
    @menus = new Menus el:@content
    @active @render

  render: ->
    @headers.active()
    @menus.active()

    
module.exports = Landings
