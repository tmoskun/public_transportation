require 'minitest/autorun'
require 'public_transportation'
require 'public_transportation/bart'
require 'public_transportation/bart/station'
require 'public_transportation/geocoding/freegeoip'
require 'public_transportation/geocoding/geokit'
require 'public_transportation/geocoding/google_distance'

class StationTest < MiniTest::Unit::TestCase
  include Transportation::BART
  include Geocoder
  
  @@data_directory = File.expand_path('../../data', __FILE__)
  @@station_directory = @@data_directory + "/station"
  @@estimate_directory = @@data_directory + "/estimate"
   
  @@fremont = Station.load_from_xml(File.read(@@station_directory + '/fremont.xml'))
  @@embarcadero  = Station.load_from_xml(File.read(@@station_directory + '/embarcadero.xml'))
  @@sixteenth = Station.load_from_xml(File.read(@@station_directory + '/16th.xml'))
  @@twenty_fourth  = Station.load_from_xml(File.read(@@station_directory + '/24th.xml'))
  @@civic  = Station.load_from_xml(File.read(@@station_directory + '/civic.xml'))
  @@balboa = Station.load_from_xml(File.read(@@station_directory + '/balboa.xml')) 
  @@glen = Station.load_from_xml(File.read(@@station_directory + '/glen.xml'))
  
  @@glen_estimate = StationEstimate.load_from_xml(File.read(@@estimate_directory + '/glen.xml'))
  @@sixteenth_estimate = StationEstimate.load_from_xml(File.read(@@estimate_directory + '/sixteenth.xml'))
  @@twenty_fourth_estimate = StationEstimate.load_from_xml(File.read(@@estimate_directory + '/twenty_fourth.xml'))
  
  IP_Austin = '99.156.82.20' 
  IP_SF = '216.75.224.38'
  Address_SF = "3416 16th St, San Francisco, CA"
  
  def test_should_get_correct_bart_stations
    stations = BART.get_station_list
    if stations != nil
      assert_instance_of(Array, stations)
      assert_includes(stations, @@fremont)
      assert_includes(stations, @@embarcadero)
      assert_includes(stations, @@sixteenth)
      assert_includes(stations, @@twenty_fourth)
      assert_includes(stations, @@civic)
      assert_includes(stations, @@balboa)
      assert_includes(stations, @@glen)
    end
  end
 
  def test_should_get_correct_closest_bart_station
    stations = BART.get_station_list
    if stations != nil
      closest_austin = GoogleDistance.get_closest(stations, IP_Austin)
      closest_sf = GoogleDistance.get_closest(stations, IP_SF)
      assert_empty(closest_austin)
      assert_includes(closest_sf, {:station => @@twenty_fourth, :time => "5 mins", :distance => '1.4 mi'})
      assert_includes(closest_sf, {:station => @@sixteenth, :time => "2 mins", :distance => '0.5 mi'})
      assert_includes(closest_sf, {:station => @@glen, :time => '8 mins', :distance => '2.7 mi'})
    end
  end
 
  def test_should_get_correct_bart_estimate
    estimates = BART.get_estimates [@@sixteenth, @@twenty_fourth, @@glen]
    if estimates != nil && estimates.size > 0
       now = DateTime.strptime(estimates.first.date + " " + estimates.first.time, "%m/%d/%Y %I:%M:%S %p %Z")  
       if business_time? now
           assert_includes(estimates, @@sixteenth_estimate)
           assert_includes(estimates, @@twenty_fourth_estimate)
           assert_includes(estimates, @@glen)
       end
    end      
  end
 
  def test_should_get_correct_estimates_for_sf
    transport = PublicTransportation.new(:ip => IP_SF, :mode => :bart)
    estimates = transport.get_closest_station_estimates
    now = DateTime.strptime(estimates.first[:estimate].date + " " + estimates.first[:estimate].time, "%m/%d/%Y %I:%M:%S %p %Z") 
    if business_time? now
       assert_includes(estimates, {:estimate => @@sixteenth_estimate, :time => "2 mins", :distance => '0.5 mi'})
       assert_includes(estimates, {:estimate => @@twenty_fourth_estimate, :time => "5 mins", :distance => '1.4 mi'})
       assert_includes(estimates, {:estimate => @@glen_estimate, :time => "8 mins", :distance => '2.7 mi'})
    end
  end
  
  def test_should_get_correct_estimates_for_austin
    transport = PublicTransportation.new(:ip => IP_Austin, :mode => :bart)
    estimates = transport.get_closest_station_estimates
    assert_empty(estimates)
  end
  
  def test_should_get_correct_estimates_by_location
    transport = PublicTransportation.new(:location => Address_SF, :mode => :bart)
    estimates = transport.get_closest_station_estimates
    now = DateTime.strptime(estimates.first[:estimate].date + " " + estimates.first[:estimate].time, "%m/%d/%Y %I:%M:%S %p %Z") 
    if business_time? now
       assert_includes(estimates, {:estimate => @@sixteenth_estimate, :time => "2 mins", :distance => '0.5 mi'})
       assert_includes(estimates, {:estimate => @@twenty_fourth_estimate, :time => "5 mins", :distance => '1.4 mi'})
       assert_includes(estimates, {:estimate => @@glen_estimate, :time => "8 mins", :distance => '2.7 mi'})
    end
  end
  
private 
  def business_time? now
    unless now.to_date.sunday?  
         t1 = DateTime.strptime("#{now.month}/#{now.day}/#{now.year} 10:00:00 AM #{now.zone}", "%m/%d/%Y %I:%M:%S %p %:z")
         t2 = DateTime.strptime("#{now.month}/#{now.day}/#{now.year} 08:00:00 PM #{now.zone}", "%m/%d/%Y %I:%M:%S %p %:z")
         return now > t1 && now < t2
    end
    return false
  end
end