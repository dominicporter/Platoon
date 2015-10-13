module.exports = class Soldier
  constructor: (@x=0, @y = 0, @speed = 256) ->
    @ready = false
    @image = new Image()

    @image.onload = =>
      @ready = true
    @image.src = 'images/hero16.png'
    @tickSum = 0

  MoveTo: (x,y) ->
    @order = "MOVE"
    @destX = x
    @destY = y
    @

  ShootAt: (x,y,rounds = 10) ->
    @order = "SHOOT"
    @targetX = x
    @targetY = y
    @targetRounds = rounds
    @

  tick: (secs) ->
    @tickSum +=secs
    if @order is "MOVE"
      @x=Math.min(@x+@speed*secs, @destX) if @destX > @x
      @x=Math.max(@x-@speed*secs, @destX) if @destX < @x
      @y=Math.min(@y+@speed*secs, @destY) if @destY > @y
      @y=Math.max(@y-@speed*secs, @destY) if @destY < @y
      @order = "" if Math.round(@x) is Math.round(@destX) and Math.round(@y) is Math.round(@destY)
    if @order is "SHOOT"
      if @tickSum > 0.5
        @shootX = @targetX + Math.random()*10-5
        @shootY = @targetY + Math.random()*10-5
        @targetRounds--
        @tickSum = 0
      @order = "" if @targetRounds is 0