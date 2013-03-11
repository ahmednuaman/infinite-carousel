config =
  numberOfItems: 8
  margin: 2
  width: 205
  speed:
    normal: 1
    fast: 4 # config.numberOfItems - (confing.margin * 2)
    timeout: 1000
  items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]

class Carousel

  constructor: (target) ->
    @animating = false
    @animationSpeed = config.speed.normal
    @animationSpeedIncrease = null
    @data = new Data()
    @dataIndex = 0
    @itemsLength = config.numberOfItems - 1
    @maxIndex = @itemsLength - config.margin
    @minIndex = config.margin
    @endPx = @itemsLength * config.width
    @initHandlebarsHelpers()
    @initTemplate target

  initHandlebarsHelpers: () ->
    Handlebars.registerHelper 'list', (items, opts) ->
      html = ''

      for i in [0...items.length]
        html += opts.fn
          index: i
          item: items[i]
          width: config.width

      html

    Handlebars.registerHelper 'multiply', (index, multiplier) ->
      return index * multiplier

  initTemplate: (target) ->
    @target = $ target

    html = @target.html()
    @template = Handlebars.compile html

    @compile
      items: @data.getData @dataIndex

  compile: (data) ->
    html = @template data
    onFocus = _.bind @focusTile, @

    @target.html html

    @target.find('li a').focus onFocus

    @tiles = @target.find('li').toArray()
    @currentIndex = config.margin

    @listenToKeyboard()
    @selectTile()

  listenToKeyboard: () ->
    $(document).keydown _.bind @handleKeyDown, @
    $(document).keyup _.bind @clearAnimationSpeedTimeout, @

  handleKeyDown: (event) ->
    switch event.keyCode
      when 37, 4 then @goToTile -@animationSpeed, event
      when 39, 5 then @goToTile @animationSpeed, event

  goToTile: (way, event) ->
    event.preventDefault()

    if @animating
      return

    @currentIndex = @currentIndex + way
    @dataIndex = @dataIndex + way

    @selectTile()

  selectTile: () ->
    @currentTile = $ @tiles[@currentIndex]
    @currentTile.find('a').focus()

  focusTile: (event) ->
    animateCallback = _.bind @tileAnimateComplete, @
    left = false
    index = @dataIndex

    if @currentIndex < @minIndex
      left = true

    else if @currentIndex > @maxIndex
      left = false

    else
      return

    # if !@animationSpeedIncrease
    #   @setAnimationSpeedTimeout()

    @animating = true
    @animateIndex = 0

    if left
      tiles = @tiles.splice -@animationSpeed

    else
      tiles = @tiles.splice 0, @animationSpeed
      index = index + config.margin

    @animateLength = @tiles.length

    data = @data.getData index
    endPx = @endPx - ((tiles.length - 1) * config.width)

    $.each tiles, (i) ->
      tile = $ this
      leftPx = (if left then 0 else endPx) + (i * config.width)
      console.log leftPx

      tile.stop(true).css
        left: leftPx

      tile.find('a').text data[i]

    incr = if left then @animationSpeed else 0

    $.each @tiles, () ->
      tile = $ this
      animateProps =
        left: incr++ * config.width

      tile.stop(true).animate animateProps,
        duration: 'normal',
        complete: animateCallback

    if left
      @tiles = tiles.concat @tiles
      @currentIndex = @minIndex

    else
      @tiles = @tiles.concat tiles
      @currentIndex = @maxIndex

    console.log @currentIndex

    @selectTile()

  tileAnimateComplete: () ->
    if ++@animateIndex is @animateLength
      @animating = false

  setAnimationSpeedTimeout: () ->
    callback = _.bind @increaseAnimationSpeed, @
    @animationSpeedIncrease = setTimeout callback, config.speed.timeout

  clearAnimationSpeedTimeout: () ->
    clearTimeout @animationSpeedIncrease
    @animationSpeedIncrease = null
    @animationSpeed = config.speed.normal

  increaseAnimationSpeed: () ->
    @animationSpeed = config.speed.fast


class Data

  constructor: () ->
    @itemsTotal = config.items.length
    @itemsLength = @itemsTotal - 1

  getData: (index) ->
    index = @verifyIndex index
    @fetchDataArray index

  getDataAt: (index) ->
    index = @verifyIndex index
    config.items[index]

  verifyIndex: (index) ->
    index = index % @itemsLength

    if index < 0
      index = @itemsTotal + index

    index

  fetchDataArray: (index) ->
    index = index - config.margin
    end = undefined

    if index > -1
      end = index + config.numberOfItems

    data = config.items.slice index, end

    if data.length < config.numberOfItems
      data = data.concat config.items.slice 0, config.numberOfItems - data.length

    data

try
  module.exports =
    Data: Data
    config: config
catch e
  $(document).ready () ->
    new Carousel '#carousel'
