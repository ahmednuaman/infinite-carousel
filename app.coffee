config =
  numberOfItems: 10
  margin: 2
  width: 100
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
    data = clone.splice index, config.numberOfItems

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
