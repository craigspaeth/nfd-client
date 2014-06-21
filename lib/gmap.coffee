require 'gmaps'

module.exports = (listing, div) ->
	gmap = new GMaps
    div: div
    lat: listing.get('location').lat
    lng: listing.get('location').lng
  gmap.addStyle
    mapTypeId: 'map_style'
    styledMapName: 'Styled Map'
    styles: [
      {
        stylers: [
          { saturation: -70 }
          { lightness: 30 }
        ]
      }
      {
        featureType: 'road'
        stylers: [
          { lightness: 30 }
        ]
      }
    ]
  gmap.setStyle 'map_style'
  gmap.addMarker
    lat: listing.get('location')?.lat
    lng: listing.get('location')?.lng
    title: listing.get('location').name
    icon: '/images/map-marker.png'