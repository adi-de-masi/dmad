require('lib/setup')
Landings = require('controllers/landings')

Spine = require('spine')

class App extends Spine.Controller
  constructor: ->
    super
    @landings = new Landings el:@el

module.exports = App
    
