require 'json'
require 'nori'
require 'rest-client'
require_relative 'config_params'

module Transportation
  module Query
     include Transportation::Config
     
     def  query_api url, cmd = nil, url_options = {}, options = {} 
       result = nil
       cmd_url = url + (cmd.nil? ? '':"#{cmd}?")
       request_url = url_options.inject(cmd_url) {|res, opt| res + "&" + opt[0] .to_s + "=" + opt[1]}
       Timeout.timeout(self.fallback_timeout) do
         result_raw = RestClient::Request.execute(:method => :get, :url => request_url, :timeout => self.timeout)
         result = result_raw.start_with?('<?xml') ? Nori.parse(result_raw) : JSON.parse(result_raw)
       end
       result
     end
             
  end
end