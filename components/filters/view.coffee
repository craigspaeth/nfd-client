_ = require 'underscore'
Backbone = require 'backbone'
numeral = require 'numeral'

module.exports = class FiltersView extends Backbone.View
  
  initialize: ->
    @params = @collection.params
    @params.on 'change', @render
    @collection.on 'sync', @renderCounts
    $(document).on 'click', @closeNeighborhoodsPopover
    
  render: =>
    # Select max rent & sort by
    @$('select option').prop 'selected', false
    @$(".filters-max-rent option[value='#{@params.get 'rent-max'}']").prop 'selected', true
    @$(".filters-sort-select option[value='#{@params.get 'sort'}']").prop 'selected', true
    # Select bedrooms & bathrooms
    @$('.rounded-tabs li').removeClass('rounded-tabs-active')
    @$(".filters-bedroom-tabs li[data-val='#{@params.get 'bed-min'}']")
      .addClass('rounded-tabs-active')
    @$(".filters-bathroom-tabs li[data-val='#{@params.get 'bath-min'}']")
      .addClass('rounded-tabs-active')
    # Render # of selected neighborhoods
    numSelected = @params.get('neighborhoods').length
    @$('.filters-location-text').html(
      if numSelected > 0
        "Selected #{numSelected} neighborhood#{if numSelected is 1 then '' else 's'}"
      else
        "Select some neighborhoods"
    )
    # Render selected neighborhoods
    for neighborhood in @params.get('neighborhoods')
      @$(".filters-location-neighborhoods-check[value=\"#{neighborhood}\"]").prop 'checked', true
  
  renderCounts: =>
    @$('.filters-count-count').html numeral(@collection.count).format('0,0')
    @$('.filters-count-total').html numeral(@collection.total).format('0,0')
    
  closeNeighborhoodsPopover: (e) =>
    expanded = $('.filters-location-arrow').hasClass('filters-location-arrow-expanded')
    clickingPopover = $(e.target).closest('.filters-location-neighborhoods').length
    clickingButton = $(e.target).closest('.filters-location-button').length
    return if not expanded or clickingPopover or clickingButton 
    @$('.filters-location-neighborhoods').hide()
    @$('.filters-location-arrow').removeClass('filters-location-arrow-expanded')
  
  events:
    'change .filters-max-rent': 'setRent'
    'click .filters-bedroom-tabs li': 'setBedrooms'
    'click .filters-bathroom-tabs li': 'setBathrooms'
    'click .filters-location-neighborhoods-check': 'setNeighborhoods'
    'change .filters-sort-select': 'setSort'
    'click .filters-location-button': 'toggleNeighborhoodsPopover'
    'click .filters-close': 'toggleNeighborhoodsPopover'
    'change .filters-location-neighborhoods-checkall': 'toggleNeighborhoodGroup'
  
  setRent: (e) ->
    @params.set 'rent-max', $(e.target).val()
    false
  
  setBedrooms: (e) ->
    @params.set 'bed-min', $(e.target).data('val')
    false
    
  setBathrooms: (e) ->
    @params.set 'bath-min', $(e.target).data('val')
    false
  
  setNeighborhoods: ->
    @params.set 'neighborhoods', @$('.filters-location-neighborhoods-check:checked').map(-> $(@).val()).toArray()
    
  setSort: (e) ->
    @params.set 'sort', $(e.target).val()
    false
  
  toggleNeighborhoodsPopover: (e) ->
    @$('.filters-location-neighborhoods').toggle()
    @$('.filters-location-arrow').toggleClass('filters-location-arrow-expanded')
  
  toggleNeighborhoodGroup: (e) ->
    checkAll = $(e.target).prop 'checked'
    $checkboxes = $(e.target).closest('ul').find('.filters-location-neighborhoods-check')
    $checkboxes.prop('checked', checkAll)
    @setNeighborhoods()