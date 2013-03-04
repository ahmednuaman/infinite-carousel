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

class Mover
  @currentIndex = 0
  @carousel
  @carouselTiles
  @itemsLength
  @leftItems
  @maxIndex
  @template

  setupCarousel: (@carousel) ->
    tiles = @carousel.target.find 'li'
    @carouselTiles = tiles.toArray()

    @initCarousel @setupMover()

  setupMover: () ->
    @itemsLength = config.items.length - 1
    @leftItems = config.numberOfItems * -1
    @maxIndex = @itemsLength + @leftItems

    @scrollTo 0

  scrollTo: (index) ->
    @currentIndex = @getCurrentIndex index
    dataArray = @getData @currentIndex - config.margin

    dataArray

  getCurrentIndex: (index) ->
    if index < @leftItems
      index = index * -1

    index = index % @itemsLength

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

    init()

try
  module.exports =
    Mover: Mover
    config: config
catch e
  $(document).ready () ->
    new Carousel '#carousel'
