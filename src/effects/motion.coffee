signal = require '../periodic/signal'

module.exports.Pulser = (item) ->
  #saw = new signal.DarkSaw()
  saw = new signal.Saw()
  this.move = () ->
    delta = 1.5 * saw.next()
    item.bounds = item.bounds.expand delta, delta
  this

module.exports.Sway = (item) ->
  saw = new signal.Saw()
  this.move = () ->
    delta = saw.next()
    item.blade.rotate(delta, item.blade.bottom)
  this

module.exports.oscillate = (item, axis, period) ->
  next = new signal.Sine period
  originalPosition = item.position
  move = ->
    delta = axis.multiply next()
    item.position = originalPosition.add delta
    delta
