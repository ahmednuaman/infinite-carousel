config =
  numberOfItems: 10
  margin: 2
  width: 200
  items: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99]

class Carousel

  constructor: (target) ->
    @data = new Data()
    @maxIndex = config.numberOfItems - config.margin - 1
    @minIndex = config.margin
    @startPx = 0
    @endPx = (config.numberOfItems - 1) * config.width
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
      items: @data.dataAt 0

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
    goToTile = _.bind @goToTile, @

    $(document).keydown (event) ->
      switch event.keyCode
        when 37 then goToTile -1
        when 39 then goToTile 1

  goToTile: (way) ->
    @currentIndex = @currentIndex + way

    @selectTile()

  selectTile: () ->
    @currentTile = $ @tiles[@currentIndex]
    @currentTile.find('a').focus()

  focusTile: (event) ->
    left = false

    if @currentIndex < @minIndex
      left = true
      tile = $ @tiles.pop()

    else if @currentIndex > @maxIndex
      tile = $ @tiles.shift()

    else
      return

    tile.stop(true).css
      left: if left then @startPx else @endPx

    incr = if left then 1 else 0

    $.each @tiles, () ->
      animateProps =
        left: incr++ * config.width

      $(this).stop(true).animate animateProps, 'normal'

    if left
      @tiles.unshift tile
      @currentIndex = @minIndex

    else
      @tiles.push tile
      @currentIndex = @maxIndex

    @selectTile()

class Data

  constructor: () ->
    @itemsTotal = config.items.length
    @itemsLength = @itemsTotal - 1

  dataAt: (index) ->
    index = @verifyIndex index
    @getData index

  verifyIndex: (index) ->
    index = index % @itemsLength

    if index < 0
      index = @itemsTotal + index

    index

  getData: (index) ->
    clone = [].concat config.items
    data = clone.splice index - config.margin, config.numberOfItems

    if data.length < config.numberOfItems
      data = data.concat clone.splice 0, config.numberOfItems - data.length

    data

try
  module.exports =
    Data: Data
    config: config
catch e
  $(document).ready () ->
    new Carousel '#carousel'
