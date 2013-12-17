# -*- encoding : utf-8 -*-
Object.class_eval do
  
  def is_active_record_array?
    if self.is_a?(Array) && !self.empty?
      data = self.map {|a| a.is_a?(ActiveRecord::Base)}
      return !data.include?(false)
    else
      return false
    end    
  end
  
end
