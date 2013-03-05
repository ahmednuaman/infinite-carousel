test:
	bash -c "mocha --reporter spec --compilers coffee:coffee-script test.coffee"

install:
	bash -c "bower install handlebars jquery lodash"

compile:
	bash -c "coffee -c app.coffee"
	bash -c "sass app.scss > app.css"