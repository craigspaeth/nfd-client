_ = require 'underscore'
Backbone = require 'backbone'
Listings = require '../../collections/listings.coffee'
FiltersView = require '../filters/view.coffee'
ListingsView = require '../listings/view.coffee'
FiltersRouter = require './router.coffee'
sd = require('sharify').data

BELOW_FOLD_PEAK = 0
START_HERO_UNIT_OPACITY = 0.4

module.exports = class HomepageView extends Backbone.View
  
  el: 'body'
  
  initialize: (options) ->
    @$window = $ window
    @listings = new Listings
    @router = new FiltersRouter pushState: true, listings: @listings
    @filtersView = new FiltersView
      collection: @listings
      el: @$('#home-page-filters')
    @listingsView = new ListingsView
      collection: @listings
      el: @$('#home-page-listings-container')
      GMaps: options?.GMaps or (require('gmaps'); GMaps)
    @$window.on 'scroll.homepagefx', @onScroll
    @$window.on 'resize.homepagefx', @resizeHeroUnit
    @listings.params.on 'change', @navigate
    @resizeHeroUnit()
    @onScroll()
    @loadHeroUnit()
  
  navigate: =>
    @router.navigate "/search/#{@listings.params.toQuerystring()}"
  
  loadHeroUnit: ->
    heroUnit = sd.HERO_UNITS[_.random(0, sd.HERO_UNITS.length - 1)]
    bgImg = new Image
    bgImg.src = heroUnit.path
    @$('#home-page-hero-unit-caption-author').text heroUnit.author
    @$('#home-page-hero-unit-caption').attr 'href', heroUnit.url
    @$('#home-page-hero-unit-img').css "background-image": "url(#{heroUnit.path})"
    bgImg.onload = ->
      setTimeout ->
        @$('#home-page-hero-unit-img-container').animate(
          (opacity: START_HERO_UNIT_OPACITY)
          1500
          -> $(@).addClass('home-page-hero-unit-loaded')
        )
      , 500
  
  resizeHeroUnit: =>
    height = @$window.height() - BELOW_FOLD_PEAK
    @$('#home-page-hero-unit').height(height)
    @$('#home-page-listings-container').css "min-height": height
  
  onScroll: =>
    return if @$window.scrollTop() < 0
    @transitionHeroUnitOpacity()
    @popLockFilters()
  
  popLockFilters: ->
    @$('#home-page-filters').removeClass('home-page-filters-fixed')
    return unless @$window.scrollTop() > @$('#home-page-filters').offset().top
    @$('#home-page-filters').addClass('home-page-filters-fixed')

  transitionHeroUnitOpacity: ->
    return unless @$('#home-page-hero-unit-img-container').hasClass('home-page-hero-unit-loaded')
    percentBetween = @$window.scrollTop() / (@$window.height() - BELOW_FOLD_PEAK)
    @$('#home-page-hero-unit-img-container').css(
      opacity: Math.min(START_HERO_UNIT_OPACITY, 1 - (percentBetween + 0.2))
    )
  
  events:
    'click #home-page-filters-search-button': 'onClickSearch'
  
  onClickSearch: ->
    @listingsView.scrollToTop()