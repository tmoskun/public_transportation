module Transportation
  module Station
     def ==(other_station)
        return false if other_station.nil?    
        #instance_variables.each do |v|
        #  return false unless eval(v.to_s + "=='" + other_station.instance_variable_get(v).to_s + "'")
        #end
        #return true
        return self.abbr == other_station.abbr
      end
      
      def method_missing(method)
         if method.to_s =~ /((latitude)|(longitude)|(abbr))/          
             instance_variables.each do |v|
               if v =~ Regexp.new($3)
                 eval("@#{v}")
                 break
               end
             end
         else
           super
         end
      end 
      
      def to_s
        inspect
      end 
             
  end
end