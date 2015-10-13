Soldier = require './soldier'
Corporal = require './corporal'

# Create the canvas
canvas = document.createElement 'canvas'
ctx = canvas.getContext '2d'
canvas.width = 800
canvas.height = 600
document.body.appendChild canvas

# Background image
bgReady = false
bgImage = new Image
bgImage.onload = ->
  bgReady = true
bgImage.src = 'images/background.png'

getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

players = []

readInConfig = () ->
  jsonString = document.getElementById("configText").value

  config =JSON.parse(jsonString)
  for soldierCfg in config
    if soldierCfg.type is "Corporal"
      corp = new Corporal(soldierCfg.x, soldierCfg.y)
      for order in soldierCfg.orders
        corp.AddOrder(order.type, order.x, order.y)
      players.push corp
      players.push dude for dude in corp.squad


reset = ->
  players = []
  readInConfig()

moveRandom = (player, modifier, distance = 1) ->
  player.x += player.speed * modifier * getRandomInt(-1 * distance, distance)
  player.x = 0 if player.x < 0
  player.x = canvas.width if player.x > canvas.width
  player.y += player.speed * modifier * getRandomInt(-1 * distance, distance)
  player.y = 0 if player.y < 0
  player.y = canvas.width if player.y > canvas.width

update = (secs) ->
  for player in players
    player.tick(secs)

render = ->
  if bgReady
    ctx.drawImage bgImage, 0, 0, canvas.width, canvas.height
  for player in players
    ctx.drawImage(player.image, player.x, player.y) if player.ready

    if player.squad and player.order
      ctx.fillStyle = "rgb(250, 250, 250)"
      ctx.font = "24px Helvetica"
      ctx.textAlign = "left"
      ctx.textBaseline = "top"
      ctx.fillText(player.order, player.x+30, player.y)
    if player.order is "SHOOT"
      ctx.beginPath();
      ctx.moveTo(player.x+8,player.y+8);
      ctx.setLineDash([4, 20]);
      ctx.lineDashOffset = Math.round(Math.random()*15)
      ctx.lineTo(player.shootX, player.shootY);
      ctx.stroke();

lastTime = null

main = ->
  now = Date.now()
  delta = now - lastTime
  update delta / 1000
  render()
  lastTime = now

  requestAnimationFrame main

# Let's play this game!
window.runGame = () ->
  lastTime = Date.now()
  reset()
  main()
