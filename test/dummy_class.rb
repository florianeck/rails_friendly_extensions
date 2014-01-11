class DummyClass
  
  # This is a dummy Class to store some Data in.
  # IN real life, this would be ActiveRecord, but because of the are no database actions 
  # required, we could just use this dummy
  
  # Store some possible data types in the class we can mess around with!
  attr_accessor :id, :sec_id,  :name, :number, :date 
  
  def initialize(options = {})
    
    self.id     = options[:id]
    self.sec_id = options[:sec_id]
    
    self.name   = options[:name]
    self.number = options[:number] || 0
    self.date   = options[:date]
    
  end  
  
  
  # Just a dummy method
  def return_self
    self
  end
  
  # Get number or number *2
  def get_number(options = {})  
    if options[:double] == true
      self.number * 2
    else
      return self.number
    end    
  end  
  
end  