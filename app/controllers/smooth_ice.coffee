Spine = require('spine')
Headers = require('controllers/headers')

class SmoothIce extends Spine.Controller
  window.smoothiceconf = {}
  window.smoothiceconf.draw_objects = "dots"
  window.smoothiceconf.vel = 3
  window.smoothiceconf.accel = 10

  setDefaults: ->
    window.smoothiceconf = {}
    window.smoothiceconf.draw_objects = "dots"
    window.smoothiceconf.vel = 3
    window.smoothiceconf.accel = 10
 
  elements:
    "#header": "header",
    "#content": "content",
    "#smoothice_resetButton": "resetButton"

  events:
    "change #flipToggleSwitch": 'toggleDotsAndCircles',
    'change #velocitySlider': 'velocityChanged',
    'change #accelerationSlider': 'accelChanged',
    'change #colorSlider': 'colorChanged',
    "click #smoothice_resetButton": "reset",
    "click #smoothice_resetColorButton": "resetColor"

  reset: ->
    @resetEvent = true
    @render()

  resetColor: ->
    window.smoothiceconf.hue = null

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
      @el.find('#dotOrCircleButton').find('.ui-btn-text').text('.')
    else
      window.smoothiceconf.draw_objects = "dots"
      @el.find('#dotOrCircleButton').find('.ui-btn-text').text('o')

  velocityChanged: (event) ->
    window.smoothiceconf.vel = event.target.value

  accelChanged: (event) ->
    window.smoothiceconf.accel = event.target.value

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
    @setDefaults()
    @headers.active()
    @el.find('#content').html require('views/smooth_ice_canvas')(@)
    canvas = document.getElementById 'canvas'
    @processing = new Processing canvas, @coffee_draw
    @el.find('#smoothice_pauseOrContinueButton').find('ui-label').text('stop')
    @el.find('#smoothice_pauseOrContinueButton').bind('click', => @pauseOrContinue(@processing))
    if @resetEvent
      @el.trigger "create"
    else
      @el.trigger "refresh"
    
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
      survivors = []
      
      if p5.frameCount % 2 == 0
        bean = new Bean(p5, {
          x: x
          y: y
          x_off: x_off
          y_off: y_off
        })
        @beans.push(bean)
      for bean in @beans
        if bean.isDrawable()
          bean.draw(@p5) 
          survivors.push bean
      @beans = survivors

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
          #vel: window.smoothiceconf.vel
        })
        @beans.push(bean)

    p5.mouseMoved= (e) -> 
      x = p5.mouseX
      y = p5.mouseY
      console.log "mouse event: x=#{x}, y=#{y}"
      x_off = p5.frameCount * 0.0003
      y_off = x_off + 20

      bean = new Bean(p5, {
        x: x
        y: y
        x_off: x_off
        y_off: y_off
        #vel: window.smoothiceconf.vel
      })
      @beans.push(bean)
      #console.log "drawed with vel=#{window.smoothiceconf.vel} and accel=#{window.smoothiceconf.accel}"

 
     
class Bean

  constructor: (@p5, opts) ->
    @x = opts.x
    @y = opts.y
    
    @x_off = opts.x_off
    @y_off = opts.y_off

    @vel = opts.vel || 3
    @accel = opts.accel || -0.003

  isDrawable: ->
    @vel > 0
    
  draw: () ->
    @x_off += 0.007
    @y_off += 0.007
    
   
    #console.log "#{@x}/#{@y} drawing point with vel=#{@vel} and accel=#{@accel}"
    if window.smoothiceconf.draw_objects is "dots"
      @drawPoint(@x_off, @y_off)
    else if window.smoothiceconf.draw_objects is "circles"
      @drawCircle(@x_off, @y_off)


  drawPoint: (x_off, y_off)->
    @vel = window.smoothiceconf.vel
    @accel = @getPointAccel()
    
    @vel += @accel
    @x += @p5.noise(@x_off) * @vel - @vel/2
    @y += @p5.noise(@y_off) * @vel - @vel/2
    
    @set_color("point")
    @p5.point(@x, @y)

  getPointAccel: ->
    cur = window.smoothiceconf.accel
    if cur is "1"
      return -0.003
    if cur is "2"
      return -0.03
    if cur is "3"
      return -0.3
    if cur is "4"
      return 0.003
    if cur is "5"
      return 0.03
    if cur is "6"
      return 0.3
    if cur is "7"
      return 1
    if cur is "8"
      return 1.5
    if cur is "9"
      return 2
    if cur is "10"
      return 3


  drawCircle: ->
    @vel = window.smoothiceconf.vel
    @accel = window.smoothiceconf.accel
    
    @vel += @accel
    @x += @p5.noise(@x_off) * @vel - @vel/2
    @y += @p5.noise(@y_off) * @vel - @vel/2
    
    @set_color("fill")
    @p5.ellipse(@x, @y, 1, 1)
    
  set_color: (mode) ->
    @p5.colorMode(@p5.HSB, 360, 100, 100)
    h = window.smoothiceconf.hue || @p5.noise((@x_off+@y_off)/2)*360
    s = 100
    b = 100
    a = 4
    if mode is "fill"
      @p5.fill(h,s,b)
    else
      @p5.stroke(h, s, b, a)

module.exports = SmoothIce
