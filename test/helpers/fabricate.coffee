# 
# Simply javascript object fabricator for json-like fixture data.
# fabricate('modelName') to create a sample js object.
# 

_ = require 'underscore'

fixtures =

'listing': ->
  id: _.uniqueId()
  rent: 3100
  beds: 1
  baths: 1
  location:
    name: "21 West Street, in Financial District"
    formatted_address: "21 West Street, Boston, MA 02111, USA"
    lng: -71
    lat: 42
    neighborhood: "Downtown Crossing"
  url: "http://streeteasy.com/nyc/rental/1140747-rental-21-west-street-financial-district-new-york"
  pictures: ["http://img.streeteasy.com/nyc/image/9/59512309.jpg", "http://img.streeteasy.com/nyc/image/66/59512266.jpg", "http://img.streeteasy.com/nyc/image/26/59512226.jpg", "http://img.streeteasy.com/nyc/image/87/59512187.jpg", "http://img.streeteasy.com/nyc/image/45/59512145.jpg", "http://img.streeteasy.com/nyc/image/8/59512108.jpg", "http://img.streeteasy.com/nyc/image/66/59512066.jpg", "http://img.streeteasy.com/nyc/image/23/59512023.jpg", "http://img.streeteasy.com/nyc/image/78/59511978.jpg", "http://img.streeteasy.com/nyc/image/48/59511948.jpg"]

'neighborhoods': ->
  Downtown: ['foo', 'bar']
  Uptown: ['foo', 'bar']
  Midtown: ['foo', 'bar']
  'North Brooklyn': ['foo', 'bar']
  'South Brooklyn': ['foo', 'bar']
  'Queens': ['foo', 'bar']
  'Bronx': ['foo', 'bar']
  'Staten Island': ['foo', 'bar']

module.exports = (modelName, extendObj) ->
  _.extend(fixtures[modelName](), extendObj)