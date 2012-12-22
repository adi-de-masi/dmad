Spine = require('spine')
Headers = require('controllers/headers')
TimeCanvas = require('controllers/time_canvas')

class Clocks extends Spine.Controller
  elements:
    "#header": "header",
    "#content": "content"

  constructor: ->
    super
    @headers = new Headers el:@header, title:"Die Uhr von Welt", back:true 
    @timeCanvas = new TimeCanvas el:@content
    @active @render


  render: ->
    @headers.active()
    @timeCanvas.active()

   
module.exports = Clocks
