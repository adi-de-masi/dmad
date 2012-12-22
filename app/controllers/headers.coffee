Spine = require('spine')

class Headers extends Spine.Controller
  constructor: ->
    super
    @active @render

  render: ->
    if @back
      @el.find('#backbutton').toggle(true)
    else
       @el.find('#backbutton').toggle(false)
    @el.find('h1').html "#{@title}"

  getTitle: ->
    @title
module.exports = Headers
