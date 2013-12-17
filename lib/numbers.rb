# -*- encoding : utf-8 -*-
# Numeric Extensions
module Numbers
  Numeric.class_eval do
  
    # Convert Number to numeric german style with precision
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
  
    # Convert Number to numeric german style without precision
    def to_de(label=nil)
      nr = self.round.to_i
      result = ActionController::Base.helpers.number_with_precision(self, :precision => 0, :separator => ",", :delimiter => ".")
      if !label.blank?
        return [result, label].join("&nbsp;").html_safe
      else
        return result
      end
    end  
  
    # Inflate number, y = duration of years, f = percentage
    # tested
    def infla(y=40,f=2)
      self.to_f*(f.to_q**y)
    end
  
    # Deflate number, y = duration of years, f = percentage
    # tested
    def defla(y=40,f=2)
      self.to_f*((1-(f.fdiv(100)))**y)
    end
  
    # Prüfen, welche Zahl aus dem Array am nächsten an der aktuellen Dran ist
    # tested
    def get_closest(nrs = [], lim = :ceil)
    
      com = {}
      com_a = []
      nrs.each do |n|
        case lim
        when :ceil
          x = ((self+0.001)-n).abs
        when :floor
          x = ((self-0.001)-n).abs
        else
          raise ArgumentError, "lim must be :ceil or :floor"
        end    
        com.merge!(x => n)
        com_a << x
      end
      return com[com_a.min]  
    end  
  
    # tested
    def min(ref)
      [self, ref].min
    end
  
    # tested
    def max(ref)
      [self, ref].max
    end
  
    # Wert zwischen den Grenzen, ansonsten ober-oder unterkante
    # tested
    def min_max(m1, m2)
      self.min(m2).max(m1)
    end  
  
    # => tested
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
  
  
    def to_time(options = {})
      values = [ self/3600, self / 60 % 60, self%60 ].map{ |t| t.to_s.rjust(2, '0') }
      if options[:split] == true
        return {:h => values[0], :m => values[1], :s => values[2]}
      else
        return values.join(':')
      end  
    end 
  
    
  end  

  Integer.class_eval do
  
  
  
    def odd?
      self%2 == 0
    end
  
    def even?
      !self.odd?
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


  Fixnum.class_eval do
    def nan?
      self.to_f.nan?
    end
  end

end

