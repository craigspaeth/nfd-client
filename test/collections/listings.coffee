sinon = require 'sinon'
Backbone = require 'backbone'
Listings = require '../../collections/listings'
fabricate = require '../helpers/fabricate'

describe 'Listings', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @listings = new Listings [fabricate('listing'), fabricate('listing')]
  
  afterEach ->
    Backbone.sync.restore()
  
  describe '#initialize', ->
    
    it 'has params that when changed reset the listings', ->
      @listings.on 'reset', spy = sinon.spy()
      @listings.params.trigger 'change'
      Backbone.sync.args[0][2].success []
      spy.called.should.be.ok
  
  describe '#fetch', ->
    
    it 'extends with the collections params', ->
      @listings.params.set 'foo', 'bar'
      @listings.fetch()
      Backbone.sync.args[0][2].data.foo.should.equal 'bar'