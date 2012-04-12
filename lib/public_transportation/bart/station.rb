require_relative '../../base/init_from_hash'
require_relative '../../base/load_from_xml'
require_relative '../station/station'

module Transportation
  module BART
    class Station
      include InitFromHash
      extend LoadFromXML
      include Transportation::Station
      
      attr_reader :name, :abbr, :gtfs_latitude, :gtfs_longitude, :address, :city, :county, :state, :zipcode
      attr_accessor :schedule, :estimate
      
      def longitude
        @gtfs_longitude
      end
      
      def latitude
        @gtfs_latitude
      end
          
      def inspect 
        "#{@name}(#{@abbr}), #{@city}, #{@state} #{@zipcode}"
      end
             
    end
  end
end