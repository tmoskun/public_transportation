require 'geo-distance'
module Geocoder
  class GoogleDistance
    
    extend Transportation::Query
    
    API_URL = "http://maps.googleapis.com/maps/api/distancematrix/json?"
    
    @@max_distance_to_system = 70 #miles
    @@max_time = 1200 #20 minutes
    
    class << self
      def get_distances origin, destinations
        distances = query_api(get_url(origin, destinations))
        destinations.instance_of?(String) ? distances[0] : distances
      end
          
      def is_close? origin, destination
        GeoDistance::Haversine.geo_distance(origin[:latitude], origin[:longitude], destination[:latitude], destination[:longitude]).miles <= @@max_distance_to_system
      end
      
      def get_geo_closest location, positions
        closest = []
        closest_distances = positions.inject({}) {|dist, pos| dist.merge({GeoDistance::Haversine.geo_distance(location[:latitude], location[:longitude], pos.latitude, pos.longitude).miles => pos})}
        closest_keys = closest_distances.keys.sort.slice(0..4)
        closest_keys.each {|k| closest.push(closest_distances[k])}
        closest
      end
      
      def get_closest positions, ip = nil, loc = nil
        location = (loc.nil? ? FreeGeoIp.location_by_ip(ip) : GeoAddress.get_location_by_address(loc))
        closest = []
        if is_close?(location, average_position(positions))
          origin = location[:latitude].to_s + "," + location[:longitude].to_s
          positions = get_geo_closest location, positions
          destinations = positions.map {|pos| pos.latitude + "," + pos.longitude}
          result = get_distances origin, destinations  
          if result["status"] == "OK"
            destination_addresses = result['destination_addresses']
            distances = result['rows'][0]["elements"]
            closest_distances = {}
            distances.each_with_index do |dist, index|
              if dist["duration"]["value"].to_i <= @@max_time
                closest_distances.merge!(dist["duration"]["value"].to_i => {:station => positions[index], :time => dist["duration"]["text"], :distance => dist["distance"]["text"]})
              end
            end
            closest_keys = closest_distances.keys.sort.slice(0..2)
            closest_keys.each {|k| closest.push(closest_distances[k])}
          end
        end
        closest
      end
      
private
            
      def get_url origin, destinations
        destination_str = destinations.instance_of?(Array) ? destinations.map {|d| process_location(d)}.join("|") : process_location(destinations)
        API_URL + URI.escape("origins=" + process_location(origin) + "&destinations=" + destination_str + "&units=imperial&sensor=false")
      end
      
      def process_location des
        if des =~ /^\s*[-+]?[0-9]*\.?[0-9]+\s*,\s*[-+]?[0-9]*\.?[0-9]+\s*$/
          des
        else
          des.split(/,\s*/).join("+")
        end
      end
      
      def average_position positions
        average_position = {:latitude => 0, :longitude => 0}
        positions.each do |p|
          average_position[:latitude] += p.latitude.to_f
          average_position[:longitude] += p.longitude.to_f
        end
        average_position.each {|k, v| average_position[k] = (v/positions.size).round(4)}
        average_position
      end
           
    end
  end    
end