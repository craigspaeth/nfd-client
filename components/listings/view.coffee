_ = require 'underscore'
Backbone = require 'backbone'
template = -> require('./templates/index.jade') arguments...
sd = require('sharify').data

FIXED_FILTER_HEIGHT = 160
MARGIN_SIZE = 20

module.exports = class ListingsView extends Backbone.View
  
  initialize: (options) ->
    @GMaps = options?.GMaps or require 'gmaps'
    @$window = $(window)
    @page = 0
    @$el.infiniteScroll @nextPage
    @collection.on 'sync', @onSync
    @collection.on 'requestReset', @onRequestReset
    @$window.on 'scroll', @onScroll
  
  onRequestReset: =>
    @$('.listings-container').addClass 'listings-loading'
    return if @$window.scrollTop() <= @listingsTop()
    @scrollToTop false
  
  scrollToTop: (animate = true) =>
    startTop = @$window.scrollTop()
    listingsTop = @listingsTop()
    if animate
      $('body, html').animate { scrollTop: listingsTop }
    else
      $('body, html').scrollTop listingsTop
  
  listingsTop: ->
    @$el.offset().top - (FIXED_FILTER_HEIGHT + @$('#main-header').height()) + MARGIN_SIZE + 5
  
  nextPage: =>
    return @$('.listings-spinner .loading-spinner').hide() if @finishedPaging
    @$('.listings-spinner .loading-spinner').show()
    @page++
    @collection.fetch data: { page: @page }, remove: false
  
  render: =>
    @$el.html template(listings: @collection.models, sd: sd)
    @renderMap()
    @onScroll()
    @$('img').error -> $(@).parent().hide()
    
  onSync: (col, res) =>
    @$('.listings-container').removeClass('listings-loading')
    @finishedPaging = res.results?.length is 0
    @render()
  
  onScroll: =>
    @setScrollRefs()
    @popLockInfo()
    @popLockMap()
    @focusOnCurrentListing()
  
  setScrollRefs: ->
    for el in @$('.listings-listing').toArray().reverse()
      if @$window.scrollTop() + FIXED_FILTER_HEIGHT + MARGIN_SIZE > $(el).offset().top
        @$currentLi = $(el)
        @currentListing = @collection.at @$currentLi.index()
        return
    @$currentLi = null
    @currentListing = null
        
  popLockInfo: ->
    @$('.listings-listing').removeClass('listings-li-locked listings-li-bottom')
    return unless @$currentLi?.length
    infoBottom = @$currentLi.find('.listings-section-left').height() + 
                 @$window.scrollTop() + FIXED_FILTER_HEIGHT
    imagesBottom = (@$currentLi.offset().top + @$currentLi.height()) - MARGIN_SIZE
    reachedBottom = infoBottom > imagesBottom
    @$currentLi.addClass("listings-li-#{if reachedBottom then 'bottom' else 'locked'}")
  
  popLockMap: ->
    if @$currentLi?.length
      @$('.listings-map').show()
    else
      @$('.listings-map, .listings-map-no-geo-cover').hide()
    if @currentListing?.hasGeoPoints()
      @$('.listings-map').removeClass('listings-map-no-geo')
      @$('.listings-map-no-geo-cover').hide()
    else if @currentListing?
      @$('.listings-map').addClass('listings-map-no-geo')
      @$('.listings-map-no-geo-cover').show()
  
  renderMap: ->
    opts = { div: @$('.listings-map')[0] }
    opts = _.extend(opts,
      if @collection.first().hasGeoPoints()
        lat: @collection.first().get('location')?.lat
        lng: @collection.first().get('location')?.lng
      else { lat: 0, lng: 0 }
    )
    @gmap = new @GMaps(opts)
    @gmap.addStyle
      mapTypeId: 'map_style'
      styledMapName: 'Styled Map'
      styles: [
        {
          stylers: [
            { saturation: -70 }
            { lightness: 30 }
          ]
        }
        {
          featureType: 'road'
          stylers: [
            { lightness: 30 }
          ]
        }
      ]
    @gmap.setStyle 'map_style'
    @collection.each (listing) =>
      return unless listing?.hasGeoPoints()
      @gmap.addMarker
        lat: listing.get('location')?.lat
        lng: listing.get('location')?.lng
        title: listing.get('location').name
        icon: '/images/map-marker.png'
  
  focusOnCurrentListing: ->
    return unless @gmap? and @currentListing?.hasGeoPoints()
    @gmap.setCenter @currentListing.get('location').lat, @currentListing.get('location').lng
    @gmap.setZoom 14