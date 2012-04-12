require_relative '../../base/init_from_hash'
require_relative '../../base/load_from_xml'
require_relative '../station/station'

module Transportation
  module BART
    class Estimate
      include InitFromHash
      extend LoadFromXML
      include Transportation::Station
      
      attr_reader :minutes, :platform, :direction, :length, :color, :bikeflag
      
      def inspect
        "#{@platform} platform - #{@minutes} minutes"
      end
         
    end
  end
end