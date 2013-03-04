config =
  numberOfItems: 10
  margin: 2
  width: 200
  items: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99]

class Carousel
  @mover
  @target

  constructor: (target) ->
    @mover = new Mover()
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

    @mover.setupCarousel @

  compile: (data) ->
    html = @template data

    @target.html html

    @target.find('li').toArray()

class Mover
  @currentIndex = 0
  @currentElement
  @carousel
  @itemsLength
  @itemsTotal
  @leftItems
  @maxIndex
  @numberOfItemsLength
  @tiles

  setupCarousel: (@carousel) ->
    @initCarousel @setupMover()

  setupMover: () ->
    @itemsTotal = config.items.length
    @itemsLength = @itemsTotal - 1
    @leftItems = config.numberOfItems * -1
    @maxIndex = @itemsLength + @leftItems
    @numberOfItemsLength = config.numberOfItems - 1

    @scrollTo 0

  scrollTo: (index) ->
    @currentIndex = @getCurrentIndex index
    dataArray = @getData @currentIndex - config.margin

    dataArray

  getCurrentIndex: (index) ->
    index = index % @itemsLength

    if index < 0
      index = @itemsTotal + index

    index

  getData: (index) ->
    clone = [].concat config.items
    data

    if index < 0
      part1 = clone.splice index, config.numberOfItems
      part2 = clone.splice 0, config.numberOfItems + index
      data = part1.concat part2

    else if index > @maxIndex
      part1 = clone.splice index, @itemsLength - index
      part2 = clone.splice 0, config.numberOfItems - part1.length
      data = part1.concat part2

    else
      data = clone.splice index, config.numberOfItems

    data

  initCarousel: (dataArray) ->
    init = _.bind @carousel.compile, @carousel,
      items: dataArray

    @tiles = init()

    @currentElement = $ '#item-' + @currentIndex
    @currentElement.find('#item-link-' + @currentIndex).focus()

    $(document).keydown _.bind @handleKeyDown, @

  handleKeyDown: (event) ->
    switch event.keyCode
      when 37 then @handleLeft event.currentTarget
      when 39 then @handleRight event.currentTarget

  handleRight: (target) ->
    tile = $ @tiles.shift()

    # $.each @tiles, (i) ->
    #   tile = $ this

    @tiles.push tile

    # tile.css 'left', @numberOfItemsLength * config.width

    dataArray = @scrollTo @currentIndex + 1
    @updateTile tile, dataArray[@numberOfItemsLength]

  handleLeft: (target) ->
    tile = $ @tiles.pop()

    @tiles.unshift tile

    # tile.css 'left', 0

    dataArray = @scrollTo @currentIndex - 1
    @updateTile tile, dataArray[0]

  updateTile: (tile, data) ->
    tile.attr 'id', 'item-' + data

    tileA = tile.find 'a'
    tileA.attr 'id', 'item-link-' + data
    tileA.text data


try
  module.exports =
    Mover: Mover
    config: config
catch e
  $(document).ready () ->
    new Carousel '#carousel'
