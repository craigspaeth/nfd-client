clientenv = require '../helpers/clientenv.coffee'
sinon = require 'sinon'
Backbone = require 'backbone'

xdescribe 'HomepageView', ->
  
  before (done) ->
    clientenv.setup 'layout/templates/index', =>
      @HomepageView = require '../../components/home-page/view'
      done()
  
  beforeEach ->
    @HomepageView::onScroll = ->
    @HomepageView::loadHeroUnit = ->
    @view = new @HomepageView el: $('body'), GMaps: sinon.stub()
  
  describe '#initialize', ->
    
    it 'adds a filters view', ->
      (@view.filtersView?).should.be.ok
      
    it 'adds a listings view', ->
      (@view.listingsView?).should.be.ok
      
describe 'HomepageRouter', ->
  
  before (done) ->
    clientenv.setup 'layout/templates/index', =>
      @HomepageRouter = require '../../components/home-page/router'
      done()
      
  it 'sets the listings params to the query params', ->
    @router = new @HomepageRouter listings: { params: new Backbone.Model } 
    @router.search 'foo=bar&baz=qux'
    @router.listings.params.toJSON().foo.should.equal 'bar'