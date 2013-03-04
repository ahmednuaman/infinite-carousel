assert = require 'assert'
app = require './app'
mover = new app.Mover()

describe 'carousel', () ->
  describe '#getCurrentIndex', () ->
    assert.ok mover.getCurrentIndex