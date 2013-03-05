// Generated by CoffeeScript 1.6.1
(function() {
  var Carousel, Data, config;

  config = {
    numberOfItems: 10,
    margin: 2,
    width: 200,
    speed: {
      normal: 600,
      fast: 200,
      faster: 10,
      timeout: 1000
    },
    items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]
  };

  Carousel = (function() {

    function Carousel(target) {
      this.animating = false;
      this.animationSpeed = config.speed.normal;
      this.animationSpeedIncrease = null;
      this.data = new Data();
      this.dataIndex = 0;
      this.itemsLength = config.numberOfItems - 1;
      this.maxIndex = this.itemsLength - config.margin;
      this.minIndex = config.margin;
      this.startPx = 0;
      this.endPx = this.itemsLength * config.width;
      this.initHandlebarsHelpers();
      this.initTemplate(target);
    }

    Carousel.prototype.initHandlebarsHelpers = function() {
      Handlebars.registerHelper('list', function(items, opts) {
        var html, i, _i, _ref;
        html = '';
        for (i = _i = 0, _ref = items.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          html += opts.fn({
            index: i,
            item: items[i],
            width: config.width
          });
        }
        return html;
      });
      return Handlebars.registerHelper('multiply', function(index, multiplier) {
        return index * multiplier;
      });
    };

    Carousel.prototype.initTemplate = function(target) {
      var html;
      this.target = $(target);
      html = this.target.html();
      this.template = Handlebars.compile(html);
      return this.compile({
        items: this.data.getData(this.dataIndex)
      });
    };

    Carousel.prototype.compile = function(data) {
      var html, onFocus;
      html = this.template(data);
      onFocus = _.bind(this.focusTile, this);
      this.target.html(html);
      this.target.find('li a').focus(onFocus);
      this.tiles = this.target.find('li').toArray();
      this.currentIndex = config.margin;
      this.listenToKeyboard();
      return this.selectTile();
    };

    Carousel.prototype.listenToKeyboard = function() {
      $(document).keydown(_.bind(this.handleKeyDown, this));
      return $(document).keyup(_.bind(this.clearAnimationSpeedTimeout, this));
    };

    Carousel.prototype.handleKeyDown = function(event) {
      switch (event.keyCode) {
        case 37:
        case 4:
          return this.goToTile(-1);
        case 39:
        case 5:
          return this.goToTile(1);
      }
    };

    Carousel.prototype.goToTile = function(way) {
      if (this.animating) {
        return;
      }
      this.currentIndex = this.currentIndex + way;
      this.dataIndex = this.dataIndex + way;
      return this.selectTile();
    };

    Carousel.prototype.selectTile = function() {
      this.currentTile = $(this.tiles[this.currentIndex]);
      return this.currentTile.find('a').focus();
    };

    Carousel.prototype.focusTile = function(event) {
      var animateCallback, data, incr, index, left, tile;
      animateCallback = _.bind(this.tileAnimateComplete, this);
      left = false;
      index = this.dataIndex;
      if (this.currentIndex < this.minIndex) {
        left = true;
      } else if (this.currentIndex > this.maxIndex) {
        left = false;
      } else {
        return;
      }
      if (!this.animationSpeedIncrease) {
        this.setAnimationSpeedTimeout();
      }
      this.animating = true;
      this.animateIndex = 0;
      if (left) {
        tile = $(this.tiles.pop());
      } else {
        tile = $(this.tiles.shift());
        index = index + 2;
      }
      tile.stop(true).css({
        left: left ? this.startPx : this.endPx
      });
      data = this.data.getDataAt(index);
      tile.find('a').text(data);
      incr = left ? 1 : 0;
      $.each(this.tiles, function() {
        var animateProps;
        animateProps = {
          left: incr++ * config.width
        };
        return $(this).stop(true).animate(animateProps, {
          duration: this.animationSpeed,
          complete: animateCallback
        });
      });
      if (left) {
        this.tiles.unshift(tile);
        this.currentIndex = this.minIndex;
      } else {
        this.tiles.push(tile);
        this.currentIndex = this.maxIndex;
      }
      return this.selectTile();
    };

    Carousel.prototype.tileAnimateComplete = function() {
      if (++this.animateIndex === this.itemsLength) {
        return this.animating = false;
      }
    };

    Carousel.prototype.setAnimationSpeedTimeout = function() {
      var callback;
      callback = _.bind(this.increaseAnimationSpeed, this);
      return this.animationSpeedIncrease = setTimeout(callback, config.speed.timeout);
    };

    Carousel.prototype.clearAnimationSpeedTimeout = function() {
      clearTimeout(this.animationSpeedIncrease);
      this.animationSpeedIncrease = null;
      return this.animationSpeed = config.speed.normal;
    };

    Carousel.prototype.increaseAnimationSpeed = function() {
      if (this.animationSpeed === config.speed.normal) {
        this.animationSpeed = config.speed.fast;
        return this.setAnimationSpeedTimeout();
      } else if (this.animationSpeed === config.speed.fast) {
        return this.animationSpeed = config.speed.faster;
      }
    };

    return Carousel;

  })();

  Data = (function() {

    function Data() {
      this.itemsTotal = config.items.length;
      this.itemsLength = this.itemsTotal - 1;
    }

    Data.prototype.getData = function(index) {
      index = this.verifyIndex(index);
      return this.fetchDataArray(index);
    };

    Data.prototype.getDataAt = function(index) {
      index = this.verifyIndex(index);
      return config.items[index];
    };

    Data.prototype.verifyIndex = function(index) {
      index = index % this.itemsLength;
      if (index < 0) {
        index = this.itemsTotal + index;
      }
      return index;
    };

    Data.prototype.fetchDataArray = function(index) {
      var clone, data;
      clone = [].concat(config.items);
      data = clone.splice(index - config.margin, config.numberOfItems);
      if (data.length < config.numberOfItems) {
        data = data.concat(clone.splice(0, config.numberOfItems - data.length));
      }
      return data;
    };

    return Data;

  })();

  try {
    module.exports = {
      Data: Data,
      config: config
    };
  } catch (e) {
    $(document).ready(function() {
      return new Carousel('#carousel');
    });
  }

}).call(this);