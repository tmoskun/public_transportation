module InitFromHash
  
  def initialize(*args)
    args.first.each do |k, v| 
      unless defined?(k).nil?    # check if it's included as a reader attribute
        result = v.instance_of?(Array) ? v.inject([]) {|arr, v1| arr << init_object(v1, k)} : init_object(v, k)
        instance_variable_set("@#{k}", result)
      end
    end if (args.length == 1 && args.first.is_a?(Hash)) 
  end
  
  def init_object value, klass
     value.instance_of?(Hash) ? (get_module_name + klass.to_s.capitalize).constantize.new(value) : value
  end
  
  def get_module_name
    (self.class.name =~ /^(.+::).+$/) ? $1 : ''
  end
    
end