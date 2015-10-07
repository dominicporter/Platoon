Soldier = require './soldier'

# Create the canvas
canvas = document.createElement 'canvas'
ctx = canvas.getContext '2d'
canvas.width = 512
canvas.height = 580
document.body.appendChild canvas

# Background image
bgReady = false
bgImage = new Image
bgImage.onload = ->
  bgReady = true
bgImage.src = 'images/background.png'

getRandomIntInclusive = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

players = []
reset = ->
  players = []
  for [1..10]
    soldier = new Soldier(canvas.width / 2, canvas.height / 2, getRandomIntInclusive(64, 256))
    soldier.MoveTo(getRandomIntInclusive(0, canvas.width), getRandomIntInclusive(0, canvas.height))
    players.push(soldier)

moveRandom = (player, modifier, distance = 1) ->
  player.x += player.speed * modifier * getRandomIntInclusive(-1 * distance, distance)
  player.x = 0 if player.x < 0
  player.x = canvas.width if player.x > canvas.width
  player.y += player.speed * modifier * getRandomIntInclusive(-1 * distance, distance)
  player.y = 0 if player.y < 0
  player.y = canvas.width if player.y > canvas.width

update = (modifier) ->
  for player in players
    player.tick(modifier)
    player.ShootAt(getRandomIntInclusive(0, canvas.width), getRandomIntInclusive(0, canvas.height)) if player.order is ""
    moveRandom(player,modifier, 1)

render = ->
  if bgReady
    ctx.drawImage bgImage, 0, 0, canvas.width, canvas.height
  for player in players
    ctx.drawImage(player.image, player.x, player.y) if player.ready
    if player.order is "SHOOT"
      ctx.beginPath();
      ctx.moveTo(player.x+8,player.y+8);
      ctx.setLineDash([5, 15]);
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
lastTime = Date.now()
reset()
main()
