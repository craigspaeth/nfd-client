Backbone = require 'backbone'
Listing = require '../../models/listing.coffee'
{ LISTING } = require('sharify').data
gmap = require '../../lib/gmap.coffee'

module.exports = class ListingPageView extends Backbone.View

  el: 'body'

  initialize: (opts) ->
    @listing = new Listing LISTING
    @renderMap()

  renderMap: ->
    return unless @listing.get('location').lat?
    gmap @listing, '#listing-page-map'