Spine = require('spine')

class TimeCanvas extends Spine.Controller
  constructor: ->
    super
    @active @render

  render: ->
    @html require('views/canvas')(@)
    canvas = document.getElementById('canvas')
    @processing = new Processing(canvas, @sketchProc)
  
  sketchProc: (processing) ->
    processing.draw = ->
      centerX = processing.width / 2
      centerY = processing.height / 2
      maxArmLength = Math.min centerX, centerY

      drawArm= (position, lengthScale, weight) ->
        processing.strokeWeight(weight)
        processing.line(centerX, centerY,
          centerX + Math.sin(position * 2 * Math.PI) * lengthScale * maxArmLength,
          centerY - Math.cos(position * 2 * Math.PI) * lengthScale * maxArmLength)

      processing.background 224
      now = new Date()
      hoursPosition = (now.getHours() % 12 + now.getMinutes() / 60) / 12
      drawArm(hoursPosition, 0.5, 5)
      minutesPosition = (now.getMinutes() + now.getSeconds() / 60) / 60
      drawArm(minutesPosition, 0.80, 3)

      secondsPosition = now.getSeconds() / 60
      drawArm(secondsPosition, 0.90, 1)
    
module.exports = TimeCanvas
