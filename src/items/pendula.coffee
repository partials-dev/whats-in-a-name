helper = require('../helper')
motion = require '../effects/motion'
mth = require '../periodic/mth'

SCHEDULING_KEY = 'pendula'
FRAME_RATE = 120
masses = []
sumMass = null
audioCtx = new (window.AudioContext || window.webkitAudioContext)()

clearExistingPendula = ->
  helper.unschedule SCHEDULING_KEY
  m.remove() for m in masses
  sumMass.remove() if sumMass?
  audioCtx.suspend()
  audioCtx.close()
  audioCtx = new (window.AudioContext || window.webkitAudioContext)()


defineOscillatorFunctions = (masses) ->
  getPeriod = (i) -> FRAME_RATE * (1 / Math.pow(2, 6)) * (60 / (65 + i))
  axis = new Point 50, 0
  masses.map (mass, i) ->
    period = getPeriod i
    oscillatorFunction = motion.oscillate mass, axis, period
    oscillatorFunction.period = period
    oscillatorFunction

updateSumMass = (deltas) ->
  sum = deltas.reduce (previous, current) ->
    return current unless previous?
    previous.add current
  sumMass.position = sumMass.data.originalPosition.add sum

synth = (frequencies) ->
  frequencies.map (freq) ->
    audibleFrequency = freq #* Math.pow 2, 8
    # osc
    oscillator = audioCtx.createOscillator()
    oscillator.type = 'sine'
    oscillator.frequency.value = audibleFrequency

    # gain
    gainNode = audioCtx.createGain()
    gainNode.gain.value = 1 / frequencies.length

    # connect nodes
    oscillator.connect gainNode
    gainNode.connect audioCtx.destination
    oscillator.start()

makePendula = (n) ->
  clearExistingPendula()

  ys = mth.regularDistribution min: 0, max: view.bounds.height, samples: n, inclusive: true
  massRadius = (ys[1] - ys[0]) / 2
  masses = (new Shape.Circle x: view.bounds.width / 4, y: y, massRadius for y in ys)

  sumMass = new Shape.Circle x: view.center.x + (view.bounds.width / 4), y: view.center.y, massRadius
  sumMass.data.originalPosition = sumMass.position

  oscillators = defineOscillatorFunctions masses
  synth oscillators.map (osc) -> 1 / (osc.period / FRAME_RATE)
  oscillateMasses = ->
    deltas = (osc() for osc in oscillators)
    updateSumMass deltas

  helper.schedule FRAME_RATE, SCHEDULING_KEY, oscillateMasses

module.exports = makePendula
