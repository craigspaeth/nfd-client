_ = require 'underscore'
Backbone = require 'backbone'
FiltersView = require '../filters/view.coffee'
ListingsView = require '../listings/view.coffee'
AlertsModal = require '../alerts-modal/view.coffee'
sd = require('sharify').data
BELOW_FOLD_PEAK = 0
START_HERO_UNIT_OPACITY = 0.75

module.exports = class HomepageView extends Backbone.View
  
  el: 'body'
  
  initialize: (opts) ->
    { @listings } = opts
    @$window = $ window
    @filtersView = new FiltersView
      collection: @listings
      el: @$('#home-page-filters')
    @listingsView = new ListingsView
      collection: @listings
      el: @$('#home-page-listings-container')
      GMaps: options?.GMaps or (require('gmaps'); GMaps)
    @alertsModal = new AlertsModal
      collection: @listings
      el: '#alerts-modal-bg'
    @$window.on 'scroll.homepagefx', @onScroll
    @$window.on 'resize.homepagefx', @resizeHeroUnit
    @resizeHeroUnit()
    @onScroll()
    @loadHeroUnit()
  
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
    return if @$window.scrollTop() < 0 or @$window.scrollTop() > @$window.height()
    @transitionHeroUnitOpacity()
    @popLockFilters()
  
  popLockFilters: ->
    @$('#home-page-filters, #main-header').removeClass('home-page-filters-fixed').addClass('main-header-home')
    return unless @$window.scrollTop() > @$('#home-page-filters').offset().top
    @$('#home-page-filters, #main-header').addClass('home-page-filters-fixed').removeClass('main-header-home')

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