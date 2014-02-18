# -*- encoding : utf-8 -*-

# Functions for True/FalseClass
module Boolean
  [TrueClass, FalseClass].each do |bclass|
  
    bclass.class_eval do
      
      # return string if true/false
      def to_real(t = "ja", f = "nein")
        case self
        when TrueClass
          return t
        else
          return f
        end    
      end  
    
      # return integer if true/false
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
end  
