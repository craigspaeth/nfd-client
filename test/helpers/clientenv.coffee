benv = require 'benv'
Backbone = require 'backbone'
fabricate = require '../helpers/fabricate'

@setup = (view, callback) ->
  benv.setup =>
    benv.expose { $: require "#{process.cwd()}/lib/zepto" }
    benv.render "#{process.cwd()}/components/#{view}.jade",
      sd:
        NEIGHBORHOODS: fabricate('neighborhoods')
        PRICES: [100, 200]
      accounting: require('accounting')
      sharify: script: ->
    , =>
      Backbone.$ = $
      callback()