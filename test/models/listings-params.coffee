Backbone = require 'backbone'
ListingsParams = require '../../models/listings-params'

describe 'ListingsParams', ->
  
  beforeEach ->
    @params = new ListingsParams
  
  describe '#toQuerystring', ->
    
    it 'turns props into query string', ->
      @params.set foo: 'bar'
      @params.toQuerystring().should.include 'foo=bar'