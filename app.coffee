config =
  numberOfItems: 10
  margin: 2
  width: 200
  items: [
    'Lorem'
    'ipsum'
    'dolor'
    'sit'
    'amet,'
    'consectetur'
    'adipiscing'
    'elit'
    'Nunc'
    'orci'
    'nunc,'
    'placerat'
    'nec'
    'aliquam'
    'ut,'
    'porta'
    'nec'
    'massa'
    'Donec'
    'vel'
    'nibh'
    'adipiscing'
    'lacus'
    'semper'
    'vulputate'
    'eu'
    'ac'
    'enim'
    'Aenean'
    'vel'
    'mauris'
    'nec'
    'mauris'
    'pretium'
    'pellentesque'
    'Morbi'
    'in'
    'mi'
    'felis,'
    'eget'
    'aliquam'
    'metus'
    'Cum'
    'sociis'
    'natoque'
    'penatibus'
    'et'
    'magnis'
    'dis'
    'parturient'
    'montes,'
    'nascetur'
    'ridiculus'
    'mus'
    'Sed'
    'fringilla'
    'risus'
    'id'
    'lectus'
    'fermentum'
    'et'
    'consequat'
    'velit'
    'feugiat'
  ]

class Carousel
  @carousel
  @mover

  constructor: (target) ->
    @initHandlebarsHelpers()
    @initTemplate target
    @compile()

  initHandlebarsHelpers: () ->
    Handlebars.registerHelper 'repeat', (len, opts) ->
      items = ''

      for i in [0...len]
        items += opts.fn
          index: i

      items

  initTemplate: (target) ->
    @carousel = $ target
    html = @carousel.html()
    @template = Handlebars.compile html

  compile: () ->
    html = @template config

    @carousel.html html

    @mover = new Mover()
    @mover.setupCarousel @carousel

class Mover
  @currentIndex = 0
  @carousel
  @carouselTiles
  @itemsLength
  @leftItems
  @maxIndex
  @template

  setupCarousel: (@carousel) ->
    tiles = @carousel.find 'li'
    @carouselTiles = tiles.toArray()

  setupMover: () ->
    @itemsLength = config.items - 1
    @leftItems = config.numberOfItems * -1
    @maxIndex = @itemsLength + @leftItems

    @scrollTo 0

  scrollTo: (index) ->
    @currentIndex = @getCurrentIndex index
    dataArray = @getData @currentIndex - config.margin

  getCurrentIndex: (index) ->
    if index < @leftItems
      index = @maxIndex

    else if index > @itemsLength
      index = 0

    index

  getData: (index) ->
    clone = [].concat config.items
    data

    if index < 0
      part1 = clone.splice index, index * -1
      part2 = clone.splice 0, config.numberOfItems + index
      data = part1.concat part2

    else if index > @maxIndex
      part1 = clone.splice index, @itemsLength - index
      part2 = clone.splice 0, config.numberOfItems - part1.length
      data = part1.concat part2

    else
      data = clone.splice index, config.numberOfItems

    data

try
  module.exports =
    Mover: Mover
catch e
  $(document).ready () ->
    new Carousel '#carousel'
