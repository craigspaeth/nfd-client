Backbone = require 'backbone'
Listing = require '../../models/listing'

describe 'ListingsParams', ->
  
  beforeEach ->
    @listing = new Listing url: 'http://foobar.com/bar/baz'
      
  describe '#formattedRent', ->
    
    it 'formats rent', ->
      @listing.set(rent: 5000).formattedRent().should.equal '$5,000'
      
  describe '#hasGeoPoints', ->
    
    it 'checks geo points based off lng & lat', ->
      @listing.set(location: {}).hasGeoPoints().should.equal false
      @listing.set(location: { lng: 1, lat: 1 }).hasGeoPoints().should.equal true
      
  describe "#bedsDisplay", ->
    
     it 'renders studios as S', ->
       @listing.set(beds: 0).bedsDisplay().should.equal 'S'
    
  describe '#sourceWebsiteName', ->
    
    it 'converts a url to a name', ->
      @listing.set(url: 'http://streeteasy.com').sourceWebsiteName().should.equal 'Street Easy'