makePendula = require './items/pendula'

# Set up paper.js
paper.install window
paper.setup 'canv'

project.currentStyle.strokeColor = 'black'
project.currentStyle.strokeWidth = 5
makePendula $("#slider")[0].value
window.makePendula = makePendula

slider = $("#slider")[0]
checkbox = $("#checkbox")[0]

$("#slider").on 'input', ->
  updatePendulums()

$("#checkbox").change ->
  updatePendulums()
  
updatePendulums = ->
  makePendula slider.value, checkbox.checked

i = 0
view.onFrame = () ->
  skip = (i % 2) is 0
  i += 1
  return if skip
  view.update()
