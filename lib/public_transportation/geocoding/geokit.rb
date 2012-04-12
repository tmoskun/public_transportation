require 'geokit'

module Geocoder
  class GeoAddress
    extend GeoKit::Geocoders
    
    class << self
      def get_location_by_address addr
        coords = MultiGeocoder.geocode(addr)
        {:latitude => coords.lat, :longitude => coords.lng}
      end
    end
    
  end
end
    
