# -*- encoding : utf-8 -*-
# Functions for True/FalseClass
[TrueClass, FalseClass].each do |bclass|
  
  bclass.class_eval do
    
    def to_real
      case self
      when TrueClass
        return "ja"
      else
        return "nein"
      end    
    end  
    
    def to_i
      case self
      when TrueClass
        return 1
      else
        return 0
      end    
    end
    
  end  

end  
