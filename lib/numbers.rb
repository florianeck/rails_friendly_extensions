# -*- encoding : utf-8 -*-
Numeric.class_eval do
  def to_euro(label = nil, options = {})
    options[:precision] ||= 2
    result = ActionController::Base.helpers.number_with_precision(self, :precision => options[:precision], :separator => ",", :delimiter => ".")
    
    if options[:pre] == true && self > 0
      result = "+#{result}"
    elsif options[:pre] == true && self < 0
      result = "-#{result}"
    end  
        
    
    if !label.blank?
      return [result, label].join("&nbsp;").html_safe
    else
      return result
    end    
  end
  
  def to_de(label=nil)
    nr = self.round.to_i
    result = ActionController::Base.helpers.number_with_precision(self, :precision => 0, :separator => ",", :delimiter => ".")
    if !label.blank?
      return [result, label].join("&nbsp;").html_safe
    else
      return result
    end
  end  
  
  
  def infla(y=40,f=2)
    self.to_f*(f.to_q**y)
  end
  
  def defla(y=40,f=2)
    self.to_f*((1-(f/100))**y)
  end
  
  # Prüfen, welche Zahl aus dem Array am nächsten an der aktuellen Dran ist
  def get_closest(nrs = [])
    com = {}
    com_a = []
    nrs.each do |n|
      x = (self-n).abs
      com.merge!(x => n)
      com_a << x
    end
    return com[com_a.min]  
  end  
  
  def min(ref)
    [self, ref].min
  end
  
  def max(ref)
    [self, ref].max
  end
  
  # Wert zwischen den Grenzen, ansonsten ober-oder unterkante
  def min_max(m1, m2)
    self.min(m2).max(m1)
  end  
  
  def fdiv(d)
    self.to_f/d
  end
  
  
  # Finanzmathematik, Zinsen und so
  def to_q
    1+(self/100.0)
  end  
  
  def alpha_sum(u,o)
    (self**u - self**(o+1)).fdiv(1-self)
  end  
    
end  

Integer.class_eval do
  
  def to_time(options = {})
    values = [ self.to_hours, self / 60 % 60, self%60 ].map{ |t| t.to_s.rjust(2, '0') }
    if options[:split] == true
      return {:h => values[0], :m => values[1], :s => values[2]}
    else
      return values.join(':')
    end  
  end 
  
  def units_to_time(date = DateTime.new(Time.now.year, Time.now.month, Time.now.day))
    if self < 0 || self > 96
      return Time.now
    else
      u1 = self - self%4
      stunde = u1/4
      DateTime.new(date.year, date.month, date.day, stunde, self%4 *15)
    end 
  end
  
  def odd?
    self%2 == 0
  end
  
  def even?
    !self.odd?
  end    
  
  def to_sentence(word_sing = "", word_plural = "", options={:capitalize => false})
    value = ""
    case self
    when 0
      value = "kein #{word_sing}"
    when 1
      value = "ein #{word_sing}"
    when 2
      value = "zwei #{word_plural}"
    when 3
      value = "drei #{word_plural}"
    when 4
      value = "vier #{word_plural}"
    when 5
      value = "fünf #{word_plural}"
    when 6
      value = "sechs #{word_plural}"
    when 7
      value = "sieben #{word_plural}"
    when 8
      value = "acht #{word_plural}"
    when 9
      value = "neun #{word_plural}"
    when 10
      value = "zehn #{word_plural}"
    when 11
      value = "elf #{word_plural}"
    when 12
      value = "zwölf #{word_plural}"
    else
      value = "#{self} #{word_plural}"
    end
    if options[:capitalize] == true
      value = value.slice(0,1).capitalize + value.slice(1..-1)
    end
    return value
  end
  
  
  # Calc seconds to hours
  def to_hours
    self / 3600
  end 

  # Cals
  def to_years(options = {:s_years => "Jahre", :s_months => "Monate", :s_sep => "und"})
    x = [self/12, self%12]
    "#{x[0]} #{options[:s_years]} #{options[:s_sep]} #{x[1]} #{options[:s_months]}"
  end
  
  def days_to_months(options = {:s_days => "Tage", :s_months => "Monate", :s_sep => "und"})
    x = [self/30, self%30]
    "#{x[0]} #{options[:s_months]} #{options[:s_sep]} #{x[1]} #{options[:s_days]}"
  end     
  
end

Float.class_eval do
  
  def to_time(options = {})
    self.to_i.to_time(options)
  end
  
  def to_hours
    self.to_i.to_hours  
  end  
  
end

Fixnum.class_eval do
  def nan?
    self.to_f.nan?
  end
end



