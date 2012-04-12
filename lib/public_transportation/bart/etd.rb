require_relative './estimate'
require_relative '../../base/init_from_hash'
require_relative '../../base/load_from_xml'
require_relative '../station/station'


module Transportation
  module BART
    class Etd
      include InitFromHash
      extend LoadFromXML
      include Transportation::Station
      
      attr_reader :abbreviation, :destination, :estimate
      
      def inspect
        "destination #{@destination} \n\t\t #{@estimate.inspect}"
      end
      
    end
  end
end