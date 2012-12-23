Spine = require('spine')
Headers = require('controllers/headers')

class SmoothIce extends Spine.Controller
  window.smoothiceconf = {}
  window.smoothiceconf.draw_objects = "dots"
  window.smoothiceconf.vel = 3
  window.smoothiceconf.accel= -0.0003
 
  elements:
    "#header": "header",
    "#content": "content",
    "#smoothice_resetButton": "resetButton"

  events:
    "click #dotOrCircleButton": 'toggleDotsAndCircles',
    'change #velocitySlider': 'velocityChanged',
    'change #accelerationSlider': 'accelChanged',
    'change #colorSlider': 'colorChanged',
    "click #smoothice_resetButton": "reset"

  reset: ->
    @render()

  pauseOrContinue: (processing) ->
    if @running
      processing.noLoop()
      @running = false
      pauseOrContinueLabel = "start"
    else
      processing.loop()
      @running = true 
      pauseOrContinueLabel = "stop"
    @el.find('#smoothice_pauseOrContinueButton').find('.ui-btn-text').text(pauseOrContinueLabel)

  
  toggleDotsAndCircles: ->
    if window.smoothiceconf.draw_objects is "dots"
      window.smoothiceconf.draw_objects = "circles"
      window.smoothiceconf.vel /= 100
      window.smoothiceconf.accel *= -100
      @el.find('#dotOrCircleButton').find('.ui-btn-text').text('.')
    else
      window.smoothiceconf.draw_objects = "dots"
      window.smoothiceconf.vel *= 100
      window.smoothiceconf.accel /= -100
      @el.find('#dotOrCircleButton').find('.ui-btn-text').text('o')

  velocityChanged: (event) ->
    window.smoothiceconf.vel = event.target.value

  accelChanged: (event) ->
    if window.smoothiceconf.draw_objects is "dots"
      tmp = event.target.value * -0.0003
    else 
      tmp = event.target.value * 0.0003
    window.smoothiceconf.accel = tmp

  colorChanged: (event) ->
    window.smoothiceconf.hue = event.target.value

  constructor: ->
    super
    @headers = new Headers el:@header, title:"smooth ice", back:true
    @running = true
    @active @render

  getPauseOrContinue: =>
    if @running
      return "stop"
    "continue"

  render: ->
    @headers.active()
    @el.find('#content').html require('views/smooth_ice_canvas')(@)
    canvas = document.getElementById 'canvas'
    @processing = new Processing canvas, @coffee_draw
    @el.find('#smoothice_pauseOrContinueButton').find('ui-label').text('stop')
    @el.find('#smoothice_pauseOrContinueButton').bind('click', => @pauseOrContinue(@processing))
    @el.trigger "create"
    
  getDotOrCircle: ->
    if window.smoothiceconf.draw_objects is 'dots'
      return 'o'
    else if window.smoothiceconf.draw_objects is 'circle'
      return '.'

  coffee_draw: (p5) ->
    p5.setup = () ->
      p5.size(800,600)
      p5.background(0)
      @beans = []
      
    p5.draw = () ->
      x_off = p5.frameCount * 0.0003
      y_off = x_off + 20
      
      x = p5.noise(x_off) * p5.width
      y = p5.noise(y_off) * p5.height
      
      if p5.frameCount % 2 == 0
        bean = new Bean(p5, {
          x: x
          y: y
          x_off: x_off
          y_off: y_off
        })
        @beans.push(bean)
      
      bean.draw() for bean in @beans

    p5.touchMove = (e) -> 
      for touch in e.touches
        x = touch.offsetX
        y = touch.offsetY
        x_off = p5.frameCount * 0.0003
        y_off = x_off + 20
        bean = new Bean(p5, {
          x: x
          y: y
          x_off: x_off
          y_off: y_off
          vel: window.smoothiceconf.vel
        })
        @beans.push(bean)

    p5.mouseMoved= (e) -> 
      x = p5.mouseX
      y = p5.mouseY
      x_off = p5.frameCount * 0.0003
      y_off = x_off + 20

      bean = new Bean(p5, {
        x: x
        y: y
        x_off: x_off
        y_off: y_off
        vel: window.smoothiceconf.vel
      })
      @beans.push(bean)
      console.log "drawed with vel=#{window.smoothiceconf.vel} and accel=#{window.smoothiceconf.accel}"

 
     
class Bean
  @drawCount = 0

  constructor: (@p5, opts) ->
    @x = opts.x
    @y = opts.y
    
    @x_off = opts.x_off
    @y_off = opts.y_off

    @vel = opts.vel || 3
    @accel = opts.accel || -0.003
    
  draw: () ->
    return unless @vel > 0
    
    @x_off += 0.007
    @y_off += 0.007
    
    @vel = window.smoothiceconf.vel
    @accel = window.smoothiceconf.accel
    
    @vel += @accel
    @x += @p5.noise(@x_off) * @vel - @vel/2
    @y += @p5.noise(@y_off) * @vel - @vel/2
    
    @set_color()
    if window.smoothiceconf.draw_objects is "dots"
      @p5.point(@x, @y)
    else if window.smoothiceconf.draw_objects is "circles"
      @p5.ellipse(@x, @y, 1,1)
    
    
  set_color: () ->
    @p5.colorMode(@p5.HSB, 360, 100, 100)
    
    h = window.smoothiceconf.hue || @p5.noise((@x_off+@y_off)/2)*360
    s = 100
    b = 100
    a = 4
    if window.smoothiceconf.draw_objects is "dots"    
      @p5.stroke(h, s, b, a)
    else if window.smoothiceconf.draw_objects is "circles"
      @p5.fill(h,s,b)
    
module.exports = SmoothIce
