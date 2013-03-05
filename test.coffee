_ = require 'lodash'
assert = require 'assert'
app = require './app'
config = app.config
data = new app.Data()
indexes = [0, 1, 10, 50, 100, 150, -1, -7, -8, -9, -10, -11, -12, -13, -50, -100, -150]

describe 'Data', () ->
  describe '#dataAt', () ->
    for target in indexes
      describe target, () ->
        entries = data.dataAt target

        it 'should return ' + config.numberOfItems + ' items starting at the ' + target + 'th - ' + config.margin + ' item', () ->
          nth = _.indexOf config.items, entries[0]

          assert.equal nth, entries[0]
          assert.equal entries.length, config.numberOfItems

  describe '#verifyIndex', () ->
    maxLength = config.items.length

    for target in indexes
      describe target, () ->
        index = data.verifyIndex target

        it 'should find the remainder between the target index and our config.items.length', () ->
          assert.ok index >= 0 && index < maxLength
