require_relative './etd'
require_relative '../../base/init_from_hash'
require_relative '../../base/load_from_xml'
require_relative '../station/station'

module Transportation
  module BART
 
    class StationEstimate
      include InitFromHash
      extend LoadFromXML
      include Transportation::Station
      
      attr_reader :name, :abbr, :date, :time, :etd
      
      def inspect
        "#{@name} at #{@date}, #{@time} \n\t #{@etd.inject('') {|str, e| (str + e.inspect + "\n\t")}}"
      end
            
    end
        
  end
end

