Spine = require('spine')

class BeastCanvas extends Spine.Controller
  food = 50
  window.dx = [0,1,1,1,0,-1,-1,-1]
  window.dy = [1,1,0,-1,-1,-1,0,1]
    
  constructor: ->
    super
    @active @render

  sketchProc: (p) ->
    p.setup = () ->
      p.size(800,600)
      p.colorMode(p.HSB, 100)
      p.noStroke()
      window.world = world = new World(p)
      window.beasts = beasts = (new Beast(p) for i in [1..5])
      p.makeFood(50000)

    p.draw = () ->
      #p.makeFood(50)
      world.draw()

      #p.stroke p.white
      survivors = []
      for beast in window.beasts
        survivors.push beast.move()
        beast.draw()
        console.log "there are #{survivors.length} survivors"

      survivors = $.map(survivors, (x) -> x) # flatten
      beasts = survivors.filter () -> true # filter nulls

    #p.mouseMoved = () ->
    #  p.stroke 255, 0, 0
    #  p.point(p.mouseX, p.mouseY)

    #p.touchStart = () -> alert 'touch start'
    #p.touchEnd = () -> alert 'touch end'
    p.touchMove = (e) -> 
      for touch in e.touches
        x = touch.offsetX
        y = touch.offsetY
        world.set x, y, 200

    p.mouseMoved = (e) -> 
      x = p.mouseX
      y = p.mouseY
      #console.log "#{x}, #{y}"
      world.set x, y, 200

    #p.touchCancel = () -> alert 'touch cancel'
    p.makeFood = (seed) ->
      for i in [1..seed]
        x = Math.floor(p.random(p.width))
        y = Math.floor(p.random(p.height))
        world.set x, y, 20


  render: ->
    @html require('views/canvas')
    canvas = document.getElementById('canvas')
    @processing = new Processing(canvas, @sketchProc)

class World
  constructor: (@p) ->
    @statemap = {}
  get: (x, y) ->
    @statemap[[x,y]]?.v
  set: (x, y, s) ->
    @statemap[[x,y]] = { x: x, y: y, v: s }
  eat: (x, y) ->
    f = @get(x, y)
    delete @statemap[[x,y]]
    f or 0
  draw: ->
    # erase background
    @p.background 0
    for key, value of @statemap
      #if @statemap[key] == 50 # regular food
      #  p.stroke 0, 0, 255
      #  p.point x, y
      if value.v == 200 # super food
        @p.fill 100, 0, 100
        @p.ellipse value.x, value.y, 3, 3
  
class Beast
  constructor: (@p, x, y, power, genes) ->
    @x = x or Math.floor(@p.random(@p.width))
    @y = y or Math.floor(@p.random(@p.height))
    @power = power or 500
    @age = 0
    @genes = genes or (Math.floor(@p.random(-10, 10)) for i in [1..8])
  geneList: ->
    result = []
    for idx in [0..@genes.length]
      for i in [1..@genes[idx]]
        result.push idx
    result
  mutate: ->
    idx = Math.floor(@p.random(8))
    updown = if @p.random() < 0.5 then -1 else 1
    @genes[idx] = @genes[idx] + updown
  split: ->
    @power = Math.floor(@power / 2)
    other = new Beast(@p, @x, @y, @power, @genes)
    other.mutate()
    @mutate()
    @age = 0
    [ @, other ]
  move: ->
    @power -= 1
    @age += 1
    list = @geneList()
    d = list[Math.floor(@p.random(list.length))]
    @x = @x + window.dx[d]
    @y = @y + window.dy[d]
    @x = 0 if @x > @p.width
    @x = @p.width if @x < 0
    @y = 0 if @y > @p.height
    @y = @p.height if @y < 0
    @power += world.eat(@x, @y)
    return null if @power == 0 # died
    return @split() if @power > 500 and @age > 150
    @ # simply survived
  draw: ->
    @p.fill(@p.color(@age / 5, 100, 100))
    @p.ellipse(@x, @y, @power / 100, @power / 100) 
   
module.exports = BeastCanvas
