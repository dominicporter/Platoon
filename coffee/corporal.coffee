Soldier = require './soldier'

module.exports = class Corporal extends Soldier
  constructor: (@x=0, @y = 0, @speed = 256) ->
    super
    @image.src = 'images/monster.png'
    @orders = []
    @squad = []
    for i in [1..7]
      soldier = new Soldier(@x+i*5,@y+i*5, Math.random()*150 + 100)
      @squad.push(soldier)
      @squad + @

  Advance: (x,y) ->
    @MoveTo x,y
    i = 1;
    for soldier in @squad
      soldier.MoveTo(x+i*5,y+i*5)
      i++
    @

  Extend: (towardsX,towardsY) ->
    i = 1;
    for soldier in @squad
      xadd = soldier.x + Math.round(Math.random() * 40) - 20
      yadd = soldier.y + Math.round(Math.random() * 40) - 20
      soldier.MoveTo(xadd,yadd)
      i++
    @MoveTo @x,@y
    @

  ShootAt: (x,y) ->
    super
    i = 1;
    for soldier in @squad
      soldier.ShootAt(x+i*2,y+i*2)
      i++
    @

  AddOrder: (type, arg1, arg2) ->
    @orders.push [type, arg1, arg2]

  squadCompletedOrders: () ->
    for soldier in @squad
      return false if soldier.order
    true

  tick: (modifier) ->
    if @squadCompletedOrders() and not @order
      if order = @orders.pop()
        console.log(order)
        if order[0] is "MOVE"
          @orders.push(["ADVANCE",order[1],order[2]])
          @orders.push(["EXTEND",order[1],order[2]])
          @order = ""
  #        @MoveTo(order[1],order[2])
        else if order[0] is "SHOOT"
          @ShootAt(order[1],order[2])
        else if order[0] is "EXTEND"
          @Extend(order[1], order[2])
        else if order[0] is "ADVANCE"
          @Advance(order[1], order[2])


    super modifier
