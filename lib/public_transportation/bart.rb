require_relative 'geocoding/freegeoip'
require_relative 'bart/station_estimate'

module Transportation
  module BART
    
  API_URL = "http://api.bart.gov/api/"
  
  #type of query
  # bsa.aspx, etd.aspx, route.aspx, sched.aspx, stn.aspx
  QUERY_TYPE = {:advisory => 'bsa.aspx', :estimate => 'etd.aspx', :route => 'route.aspx', :schedule => 'sched.aspx', :station => 'stn.aspx'}
  
  # all commands
  #'bsa', 'count', 'elev', 'stnaccess','stninfo', 'stns', 'etd', 'routeinfo', 'routes', 'arrive', 'depart', 'fare', 'holiday', 'route_sched', 'scheds', 'special', 'stnsched'
  
  #commands
  #bsa.aspx
  ADVISORY_MESSAGE = 'bsa'
  ACTIVE_TRAINS = 'count'
  ELEVATOR_INFO = 'elev'
  #etd.aspx
  DEPARTURE_ESTIMATE = 'etd'
  #route.aspx
  ROUTE_INFO = 'routeinfo'
  ROUTES = 'routes'    
  #sched.aspx
  ARRIVE = 'arrive'
  DEPART = 'depart'
  FARE = 'fare'
  HOLIDAY = 'holiday'
  ROUTE_SCHEDULE = 'route_sched'
  SCHEDULES = 'scheds'
  SPECIAL = 'special'
  STATION_SCHEDULE = 'stnsched'
  #stn.aspx
  STATION_INFO = 'stninfo'
  STATIONS = 'stns'
  STATION_ACCESS = 'stnaccess'
   
    class BART
      
      extend Transportation::Query
           
      @@api_key = 'MW9S-E7SL-26DU-VV8V'
     
      class << self
        def api_key
          @@api_key
        end
        
        def api_key= api_key
          @@api_key = api_key
        end
        
        def get_station_list
          query_api(API_URL, QUERY_TYPE[:station], :cmd => STATIONS, :key => @@api_key)["root"]["stations"]["station"].map {|s| Station.new(s)}
        end
        
        def get_estimates stations
          stations.instance_of?(Array) ? (stations.inject([]) {|est, st| est << get_station_estimate(st)}) : get_station_estimate(stations)
        end
        
private
        def get_station_estimate station
          est = query_api(API_URL, QUERY_TYPE[:estimate], :cmd => DEPARTURE_ESTIMATE, :key => @@api_key, :orig => station.abbr)["root"]
          StationEstimate.new({"date" => est["date"], "time" => est["time"]}.merge(est["station"]))
        end
                        
      end
    
    end 
    
  end
    
end


