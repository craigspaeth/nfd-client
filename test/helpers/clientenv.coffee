benv = require 'benv'
Backbone = require 'backbone'
fabricate = require '../helpers/fabricate'

benv.globals = ->
  $: require "#{process.cwd()}/lib/zepto"

@setup = (view, callback) ->
  benv.setup =>
    benv.render "#{process.cwd()}/components/#{view}.jade",
      sd:
        NEIGHBORHOODS: fabricate('neighborhoods')
        PRICES: [100, 200]
      accounting: require('accounting')
      sharifyScript: ->
    , =>
      Backbone.$ = $
      callback()