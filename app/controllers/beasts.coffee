Spine = require('spine')
Headers = require('controllers/headers')
BeastCanvas = require('controllers/beast_canvas')

class Beasts extends Spine.Controller

  elements:
    "#header": "header",
    "#content": "content"

  constructor: ->
    super
    @headers = new Headers el:@header, title:"The Beast", back:true
    @beastCanvas = new BeastCanvas el:@content
    @active @render


  render: ->
    @headers.active()
    @beastCanvas.active()
   
module.exports = Beasts
