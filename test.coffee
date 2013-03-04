_ = require 'lodash'
assert = require 'assert'
app = require './app'
config = app.config
mover = new app.Mover()

describe 'carousel', () ->
  describe '#setupMover', () ->
    entries = mover.setupMover()

    it 'should return the last ' + config.margin + ' and the first ' + (config.numberOfItems - config.margin) + ' entries from our items', () ->
      clone = [].concat config.items
      last = clone.splice config.margin * -1
      first = clone.splice 0, config.numberOfItems - config.margin
      total = last.concat first

      assert.ok _.isEqual entries, total

    it 'should return ' + config.numberOfItems + ' items', () ->
      assert.equal entries.length, config.numberOfItems

