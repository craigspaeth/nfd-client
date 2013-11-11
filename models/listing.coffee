Backbone = require 'backbone'
sd = require('sharify').data
accounting = require 'accounting'
url = require 'url'
moment = require 'moment'

module.exports = class Listing extends Backbone.Model
  
  urlRoot: -> "#{sd.API_URL}/listings"
  
  formattedRent: ->
    accounting.formatMoney @get('rent'), '$', 0
  
  sourceWebsiteName: ->
    hostname = url.parse(@get 'url').hostname
    switch host
      when 'streeteasy.com' then 'Street Easy'
      when 'www.nybits.com' then 'NYBits'
      when 'www.urbanedgeny.com' then 'Urban Edge'
      when 'apartable.com' then 'Apartable'
      when 'trulia.com' then 'Trulia'
      when 'www.renthop.com' then 'RentHop'
      when 'www.9300realty.com' then '9300 Realty'
      when 'http://www.iconrealtymgmt.com/' then 'Icon Realty'
      when 'www.nofeerentals.com' then 'Nofeerentals'
      when 'gonofee.com' then 'go no fee'
      else hostname
        
  hasGeoPoints: ->
    @get('location')?.lng? and @get('location')?.lat?
  
  bedsDisplay: ->
    if @get('beds') is 0 then 'S' else @get('beds') or '?'
    
  listedAgo: ->
    moment(@get('dateScraped')).fromNow()
  
  listedAgoClass: ->
    daysAgo = moment().diff @get('dateScraped'), 'days'
    if daysAgo < 3
      'listings-listed-ago-good'
    else if daysAgo < 7
      'listings-listed-ago-medium'
    else
      'listings-listed-ago-bad'