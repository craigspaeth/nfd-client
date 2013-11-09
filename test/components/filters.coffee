Backbone = require 'backbone'
sinon = require 'sinon'
clientenv = require '../helpers/clientenv'
fabricate = require '../helpers/fabricate'
Listings = require '../../collections/listings'

describe 'FiltersView', ->
  
  before (done) ->
    clientenv.setup 'home-page/index', =>
      @FiltersView = require '../../components/filters/view'
      done()
      
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @view = new @FiltersView
      el: $('body')
      collection: new Listings [fabricate 'listing']
  
  afterEach ->
    Backbone.sync.restore()
  
  describe '#toggleNeighborhoodsPopover', ->
    
     it 'shows the neighborhoods list', ->
       @view.$('.filters-location-neighborhoods').hide()
       @view.toggleNeighborhoodsPopover()
       @view.$('.filters-location-neighborhoods').attr('style').should.include 'display: none'
  
  describe '#render', ->
    
    it 'renders the state of the params', ->
      @view.params.set 'bed-min': 2
      @view.$(".filters-bedroom-tabs .rounded-tabs-active").index().should.equal 2
      
    it 'renders counts on sync', ->
      @view.collection.total = 8503
      @view.collection.trigger 'sync'
      @view.$el.html().should.include '8,503'
  
  describe '#setBedrooms', ->
  
    it 'sets the bed_max', ->
      @view.$('.filters-bedroom-tabs li').eq(1).click()
      @view.params.get('bed-min').should.equal 1
      
  describe '#setBathrooms', ->
  
    it 'sets the bed_max', ->
      @view.$('.filters-bathroom-tabs li').eq(1).click()
      @view.params.get('bath-min').should.equal 1.5
      
  describe '#setRent', ->
  
    it 'sets the bed_max', ->
      @view.setRent target: $ "<input value='1002'>"
      @view.params.get('rent-max').should.equal '1002'
  
  describe '#setNeighborhoods', ->
  
    it 'serialized the checked neighborhoods', ->
      @view.$('.filters-location-neighborhoods .filters-location-neighborhoods-check')
        .first().attr('checked', true).val 'foobar'
      @view.setNeighborhoods()
      ('foobar' in @view.params.get('neighborhoods')).should.be.ok
  
  describe '#setSort', ->
  
    it 'sorts by the select value', ->
      @view.setSort target: $ "<input value='rent'>"
      @view.params.get('sort').should.equal 'rent'