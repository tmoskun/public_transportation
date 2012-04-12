require_relative '../query'

module Geocoder
  class FreeGeoIp
    
    extend Transportation::Query
    
    class << self
      def location_by_ip ip = nil, options = {}       
        location = query_api(lookup_url(ip, options))
        convert_keys! location unless location.nil? 
        location
      end
          
      private
        def lookup_url ip = nil, options = {} 
          raise 'Invalid IP address' unless (ip.nil? || ip.to_s =~ IPV4_REGEXP) 
          "http://freegeoip.net/json/#{ip.nil? ? '':ip}"
        end
               
        def convert_keys! data, options = {}
          #data.keys.inject({}) {|res, key| res.merge({key.gsub(/^[A-Z][a-z]+([A-Z])?[a-z]?$/, '_\1').downcase => data[key]})}
          data.keys.each do |key|
            if key =~ /^([A-Z][a-z]+)([A-Z][a-z]+)$/
              data[("#{$1}_#{$2}").downcase.to_sym] = data[key]
            else
              data[key.downcase.to_sym] = data[key]
            end
            data.delete(key)
          end
        end 
    end  
    
        
  end
end