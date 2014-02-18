# -*- encoding : utf-8 -*-
module SmartCurrency
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def smart_currency
      unless smart_currency?
          include InstanceMethods
          auto_attributes = []
          self.skip_time_zone_conversion_for_attributes = []
          attributes = self.columns.select {|c| (c.type == :integer || c.type == :decimal) && !c.name.match("id") }
          
          attributes.each do |a|
            define_method("#{a.name}=") do |val|
              self[a.name.to_sym] = currency_to_db(val)
            end  
          end  
          
      end    
    end
    
    def smart_currency?
      self.included_modules.include?(InstanceMethods)
    end
    
  end  

  module InstanceMethods # any method placed here will apply to instaces, like @hickwall  
    
    def currency_to_db(string)
      if string.is_a?(String) 
        return (string.gsub(/\./, '').gsub(/,/, '.')).to_f
      elsif string.nil?
        return 0
      else  
        return string
      end      
    end

    def currency_to_view(decimal)
      if !decimal.nil?
        str = decimal.to_s.split(".")
        str[1] = "0" unless str[1]
        if str[1].size == 1
          str[1] += "0"
        end
        if str[0].size == 5 || str[0].size == 6
          str[0].gsub!(/\B([0-9]{3})\b/,'.\1')
        elsif str[0].size > 7
          str[0].gsub!(/([0-9]{3})\b/,'.\1').gsub!(/([0-9]{3}\.)/, '.\1') 
        else
          str[0].gsub!(/\B([0-9]{3})/,'.\1')  
        end
        str[1].size > 2 ? str[1] = str[1][0..1] : nil
        return (str[0] + "," + str[1]).to_s  
      else                                 
        return "keine Angabe"
      end  
    end
    
  end
   
end
