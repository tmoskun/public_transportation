require 'minitest/autorun'
require 'public_transportation/geocoding/freegeoip'

class FreegeoipTest < MiniTest::Unit::TestCase
  
  include Geocoder
   
  IP = '99.156.82.20'
  
  def test_should_get_location_by_ip
    location = FreeGeoIp.location_by_ip IP
    unless location.nil?
      assert_equal(location[:ip], IP)
      assert_equal(location[:country_code], 'US')
      assert_equal(location[:country_name], 'United States')
      assert_equal(location[:region_code], 'TX')
      assert_equal(location[:region_name], 'Texas')
      assert_equal(location[:latitude], '30.5321')
      assert_equal(location[:longitude], '-97.7286')
    end
  end 
  
end