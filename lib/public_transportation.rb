require "public_transportation/version"
require "public_transportation/geocoding/google_distance"
require "public_transportation/bart"

class PublicTransportation
  
    include Transportation::BART
    include Geocoder
      
    @@MODES = [:bart]
    
    attr_accessor :mode, :ip, :location
       
    def initialize(*args)
      options = args.extract_options!
      self.ip = options.delete(:ip)
      self.location = options.delete(:location)
      self.mode = options.delete(:mode) || @@MODES
    end
    
    def get_closest_station_estimates  
      modes = mode.instance_of?(Array) ? mode : [mode]
      stations = modes.inject({}) {|st, m| st.merge(m => get_class(m).get_station_list)} 
      estimates = stations.keys.inject([]) do |est, m|
        closest = GoogleDistance.get_closest(stations[m], self.ip, self.location)
        klass = get_class(m)
        closest.inject(est) {|e, st| e << {:estimate => klass.get_estimates(st[:station]), :time => st[:time], :distance => st[:distance]}}
      end
      estimates    
    end
    
private
    def get_class name
      "Transportation::#{name.to_s.upcase}::#{name.to_s.upcase}".constantize
    end
    
end
