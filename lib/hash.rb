# -*- encoding : utf-8 -*-
Hash.class_eval do
  
  def to_s
    str = ""
    self.each do |key, value|
      str << "#{key} => #{value}, "
    end  
  end
  
  def ordered(by = 1)
    if by == :key
      by = 0
    elsif by == :value
      by = 1
    end    
    self.to_a.sort_by {|x| x[by].inspect}
  end
  
  def extract_data(slice = nil, trigger = "1")
    data = []
    self.each do |value, status|
      if slice.nil?
        data << value if status == trigger
      else  
        data << value.split(slice).last if status == trigger
      end  
    end
    return data
  end  
  
  def to_url(options = {})
    # alles auf symbol mappen!
    mapped_hash = {}
    self.each {|k,v| mapped_hash.merge!(k.to_sym => v)}
    
    
    # controller und action  und ID filtern
    url = ""
    if mapped_hash[:controller] || options[:controller]
      url << "/#{(self[:controller] || options[:controller])}"
    end
    
    if mapped_hash[:action] || options[:action]
      url << "/#{(self[:action] || options[:action])}"
    end
    
    if mapped_hash[:id] || options[:id]
      url << "/#{(self[:id] || options[:id])}"
    end    
      
      elements = []
      mapped_hash.except(:controller, :action, :id).each do |k,v|
        elements << "#{k.to_s}=#{v}"
      end
    
    unless elements.empty?
      url << "?#{elements.join('&')}"
    end  
    
    return url
  end  
         
  
end
