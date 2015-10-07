module.exports = class Soldier
  constructor: (@x=0, @y = 0, @speed = 256) ->
    @ready = false
    @image = new Image()

    @image.onload = =>
      @ready = true
    @image.src = 'images/hero16.png'

  MoveTo: (x,y) ->
    @order = "MOVE"
    @destX = x
    @destY = y

  ShootAt: (x,y) ->
    @order = "SHOOT"
    @targetX = x
    @targetY = y

  tick: (modifier) ->
    if @order is "MOVE"
      @x=Math.min(@x+@speed*modifier, @destX) if @destX > @x
      @x=Math.max(@x-@speed*modifier, @destX) if @destX < @x
      @y=Math.min(@y+@speed*modifier, @destY) if @destY > @y
      @y=Math.max(@y-@speed*modifier, @destY) if @destY < @y
      @order = "" if Math.round(@x) is @destX and Math.round(@y) is @destY
    if @order is "SHOOT"
      @shootX = @targetX + Math.random()*10-5;
      @shootY = @targetY + Math.random()*10-5;