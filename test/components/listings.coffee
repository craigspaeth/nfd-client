Backbone = require 'backbone'
clientenv = require '../helpers/clientenv'
benv = require 'benv'
fabricate = require '../helpers/fabricate'
sinon = require 'sinon'
Listings = require '../../collections/listings'

describe 'ListingsView', ->
  
  before (done) ->
    clientenv.setup 'layout/templates/index', =>
      @ListingsView = benv.requireWithJadeify '../../components/listings/view', ['template']
      done()
      
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @ListingsView::scrollToTop = sinon.stub()
    @view = new @ListingsView
      collection: new Listings
      el: $('body')
      GMaps: sinon.stub()
    
  afterEach ->
    Backbone.sync.restore()
  
  context 'stubbing #renderMap', ->
    
    beforeEach ->
      @view.renderMap = sinon.stub()
  
    describe '#initialize', ->
    
       it 'renders on sync', ->
         spy = sinon.spy @view, 'onSync'
         @view.initialize()
         @view.collection.trigger 'sync', {}, [{},{}]
         spy.called.should.be.ok
         
      it 'infinite scrolls', ->
        @view.nextPage = spy = sinon.spy()
        @view.initialize()
        $(window).trigger 'infiniteScroll'
        spy.called.should.be.ok
       
    describe '#render', ->
    
      it 'renders listings', ->
        @view.onScroll = ->
        @view.collection.reset [fabricate('listing', beds: '405')]
        @view.render()
        @view.$el.html().should.include '405'
      
  describe '#renderMap', ->
    
    it 'adds google maps to the view with the first listings as default', ->
      args = null
      @view.GMaps = class GMapStub
        constructor: -> args = arguments
        addMarker: sinon.stub()
        addStyle: ->
        setStyle: ->
      @view.collection.reset [fabricate('listing', location: { lat: 1, lng: 2 })]
      @view.renderMap()
      args[0].lat.should.equal 1
      args[0].lng.should.equal 2
      
    it 'adds markers for each listings', ->
      args = []
      @view.GMaps = class GMapStub
        addMarker: -> args.push arguments
        addStyle: ->
        setStyle: ->
      @view.collection.reset [
        fabricate('listing', location: { lat: 17, lng: 20 })
        fabricate('listing', location: { lat: 25, lng: 20 })
      ]
      @view.renderMap()
      args[0][0].lat.should.equal 17
      args[1][0].lat.should.equal 25
      
  describe '#focusOnCurrentListing', ->
    
    it 'sets the maker to the current listing', ->
      @view.gmap = setCenter: sinon.stub(), setZoom: ->
      @view.collection.reset [fabricate('listing', location: { lng: 100, lat: 101 })]
      @view.currentListing = @view.collection.first()
      @view.focusOnCurrentListing()
      @view.gmap.setCenter.args[0][1].should.equal 100
      @view.gmap.setCenter.args[0][0].should.equal 101
  
  describe '#nextPage', ->
    
    it 'fetches the next page', ->
      @view.nextPage()
      @view.nextPage()
      Backbone.sync.args[1][2].data.page.should.equal 2