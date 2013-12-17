# -*- encoding : utf-8 -*-
module HashExt
  Hash.class_eval do
  
  
    # returns an array containing the hash values
    # ordered either by hash key or hash value
    # userful for building select_tag data from hash
    # tested
    def ordered(by = 1)
      if by == :key
        by = 0
      elsif by == :value
        by = 1
      end    
      self.to_a.sort_by {|x| x[by].inspect}
    end
  
  
    # useful function for extracting form data from serveral checkboxes which will return a hash like:
    # {:chk_1, => 0, :chk_2, => 1, :chk_3, => 1, ...}
    # .extract_data would return [:chk_2, :chk_3]
    # using slice = "chk_" would return [2,3]
    def extract_data(slice = nil, trigger = "1")
      data = []
      self.each do |value, status|
        value = value.to_s
        if slice.nil?
          data << value if status == trigger
        else  
          data << value.split(slice).last if status == trigger
        end  
      end
      return data
    end  
  
  end
end