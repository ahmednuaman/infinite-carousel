class Carousel
  @carousel
  @template

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
    html = @template
      numberOfItems: 10

    @carousel.html html

$(document).ready () ->
  new Carousel '#carousel'