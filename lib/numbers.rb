# -*- encoding : utf-8 -*-
# Numeric Extensions
module Numbers

  Numeric.class_eval do

    # Convert Number to numeric german style with precision
    def to_euro(label = nil, options = {})
      options[:precision] ||= 2

      options[:precision] = 0 if options[:fix_int] == true && self.is_a?(Integer)

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
      self.to_euro(label, :precision => 0)
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
      [self.to_f, ref.to_f].min
    end

    # tested
    def max(ref)
      [self.to_f, ref.to_f].max
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
      values = [ self.to_i/3600, self.to_i / 60 % 60, self.to_i%60 ].map{ |t| t.to_s.rjust(2, '0') }
      if options[:split] == true
        return {:h => values[0].round, :m => values[1].round, :s => values[2].round}
      elsif options[:discard_hour] == true && values[0] == "00"
        return values[1,2].join(':')
      else
        return values.join(':')
      end
    end

    def deg2rad
      self * Math::PI / 180
    end

    def nan?
      self.to_f.nan?
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


    # Split number in smallest prime factors
    def prime_factors(options = {})
      options[:nrs] ||= Math.sqrt(self).floor.prime_numbers
      options[:nrs].each_with_index do |n,i|
        if self%n == 0
          return [n, (self/n).prime_factors(:nrs => options[:nrs])].flatten.except(1)
        elsif i == options[:nrs].size-1
          return [self]
        end
      end
    end

    # Create list with prime numbers up to 'self'
    def prime_numbers
      s = (0..self).to_a
      s[0] = s[1] = nil
      s.each do |p|
        next unless p
        break if p * p > self
        (p*p).step(self, p) { |m| s[m] = nil }
      end
      s.compact
    end

  end



end

