makePendula = require './items/pendula'

# Set up paper.js
paper.install window
paper.setup 'canv'

project.currentStyle.strokeColor = 'black'
project.currentStyle.strokeWidth = 5
makePendula $("#slider")[0].value
window.makePendula = makePendula
$("#slider").on 'input', ->
  makePendula this.value
  
i = 0
view.onFrame = () ->
  skip = (i % 2) is 0
  i += 1
  return if skip
  view.update()
