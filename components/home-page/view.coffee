_ = require 'underscore'
Backbone = require 'backbone'
Listings = require '../../collections/listings.coffee'
FiltersView = require '../filters/view.coffee'
ListingsView = require '../listings/view.coffee'
FiltersRouter = require './router.coffee'

BELOW_FOLD_PEAK = 0
START_HERO_UNIT_OPACITY = 0.4
HERO_UNITS = [
  {
    path: 'http://farm8.staticflickr.com/7216/7165051233_befdd890b8_b.jpg'
    url: 'http://www.flickr.com/photos/jnarber/7165051233/in/photolist-bV9L76-fhEdXi-8RR5BR-7xMBVN-cQwRpN-dkJxg5-djX4sB-azxoTY-azuJFg-azxoB9-7FgPBB-bCa6Zo-afSNR4-8Zq6oa-8Zq6jF-8Zta8s-8ZtabY-euWgxT-dTAJh5-9DUf7b-9DRUox-bWF2AZ-9DT8AH-bHVDEM-9n8VLS-euZn6Y-euWfpi-euZo11-cmw3oo-cmw2Pj-cmvnSC-cmvvB3-cmv6Vw-cmw15b-cmvLVs-cmv8Eh-cmvZyq-cmvapd-cmvL9Y-9DRUyk-9DRSzP-9DZimC-dHLu7j/'
    author: 'Jared Narber'
    pos: 'top'
  }
  {
    path: 'http://farm7.staticflickr.com/6052/6279775284_97cf791721_b.jpg'
    url: 'http://www.flickr.com/photos/edrost88/6279775284/sizes/o/'
    author: 'Erik Drost'
    pos: 'center'
  }
  {
    path: 'http://farm1.staticflickr.com/41/104838613_d2b262878e_b.jpg'
    url: 'http://www.flickr.com/photos/jul/104838613/'
    author: 'Julien Menichini'
    pos: 'center'
  }
  {
    path: 'http://farm4.staticflickr.com/3587/3584915920_1d68337526_o.jpg'
    url: 'http://www.flickr.com/photos/sidelife/3584915920/sizes/o/'
    author: 'Arsenie Coseac'
    pos: 'center'
  }
  {
    path: 'http://farm3.staticflickr.com/2571/4061232914_0241752ed1_b.jpg'
    url: 'http://www.flickr.com/photos/sackerman519/4061232914/'
    author: 'Sarah Ackerman'
    pos: 'bottom'
  }
  {
    path: 'http://farm8.staticflickr.com/7110/7038011669_f822cf6750_b.jpg'
    url: 'http://www.flickr.com/photos/99472898@N00/7038011669/in/photolist-bHVDEM-9n8VLS-euZo11-euWgxT-cmw3oo-cmw2Pj-cmvnSC-9DZimC-arX3XD-arXc5r-arXpfi-arX8iz-arZsou-arZGoo-arZ8ny-arWZpk-arWCJ4-arWSw6-arZwxN-arWGqP-arX71D-arZhDU-arZaSU-arZmcu-9uYc9R-arZWJU-arWzRg-c6p1DN-dTM5oD-avTYLK-7QrmKr'
    author: 'Kenny Louie'
    pos: 'top'
  }
  {
    path: 'http://farm2.staticflickr.com/1390/853546651_41ff333849_b.jpg'
    url: 'http://www.flickr.com/photos/jenniferwoodardmaderazo/853546651/'
    author: 'Jennifer Woodard Maderazo'
    pos: 'bottom'
  }
]

module.exports = class HomepageView extends Backbone.View
  
  el: 'body'
  
  initialize: ->
    @$window = $ window
    @listings = new Listings
    @router = new FiltersRouter pushState: true, listings: @listings
    @filtersView = new FiltersView
      collection: @listings
      el: @$('#home-page-filters')
    @listingsView = new ListingsView
      collection: @listings
      el: @$('#home-page-listings-container')
      GMaps: @options.GMaps or (require('gmaps'); GMaps)
    @$window.on 'scroll.homepagefx', @onScroll
    @$window.on 'resize.homepagefx', @resizeHeroUnit
    @listings.params.on 'change', @navigate
    @resizeHeroUnit()
    @onScroll()
    @loadHeroUnit()
  
  navigate: =>
    @router.navigate "/search/#{@listings.params.toQuerystring()}", trigger: true
  
  loadHeroUnit: ->
    heroUnit = HERO_UNITS[_.random(0, HERO_UNITS.length - 1)]
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
          'cubic-bezier(0.215, 0.610, 0.355, 1.000)'
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