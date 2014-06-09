Backbone = require 'backbone'
GMaps = require 'gmaps'
Listing = require '../../models/listing.coffee'
{ LISTING } = require('sharify').data

module.exports = class ListingPageView extends Backbone.View

  el: 'body'

  initialize: (opts) ->
    @listing = new Listing LISTING
    @renderMap()

  renderMap: ->
    return unless @listing.get('location').lat?
    new GMaps
      div: '#listing-page-map'
      lat: @listing.get('location').lat
      lng: @listing.get('location').lng