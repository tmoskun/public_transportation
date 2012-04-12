require_relative '../../base/init_from_hash'
require_relative '../../base/load_from_xml'
require_relative '../station/schedule'

module Transportation
  module BART
    class Schedule
      include InitFromHash
      extend LoadFromXML
      include Transportation::Station
      
      
      
      
    end
  end
end