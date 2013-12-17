# -*- encoding : utf-8 -*-
Date.class_eval do
  
  def self.new_from_params(p)
    return Date.new(p["starts_at(1i)"].to_i, p["starts_at(2i)"].to_i, p["starts_at(3i)"].to_i)
	end
  
	def to_german_date
		self.to_de
	end
	
	def to_short_stamp(options = {})
		return self.strftime('%d%m%y')
	end
	
	def age_calc
	  now = Time.now.to_date
    now.year - self.year - (self.change(:year=>now.year)>now ? 1 : 0) #rescue 0
	end  
	
	def next_month
    return self+1.month
	end
	
	def prev_month
    return self-1.month
	end    
	
	def to_de(options = {})
    self.strftime('%d.%m.%Y')
	end
	
	def short_date
	  self.strftime('%d.%m.')
	end  
	
	def to_sql
	  self.strftime('%Y-%m-%d')
	end  
	
	def month_name
	  MONTH_TO_VIEW[self.month] rescue self
	end
	
	def month_name_full
	  "#{MONTH_TO_VIEW[self.month]} #{self.year}"
	end  
	
	def month_label
	  self.strftime('%m/%Y')
	end  
	
	def to_i
	  self.to_s.gsub("-", "").to_i
	end  
	
	def to_zodiac
	  zodiacs = {
          [1,  1,  1,  20] => "Steinbock",
          [1,  21, 2,  19] => "Wassermann",
          [2,  20, 3,  20] => "Fische",
          [3,  21, 4,  20] => "Widder",
          [4,  21, 5,  21] => "Stier",
          [5,  22, 6,  21] => "Zwilling",
          [6,  22, 7,  22] => "Krebs",
          [7,  23, 8,  21] => "Löwe",
          [8,  22, 9,  23] => "Junfrau",
          [9,  24, 10, 23] => "Wage",
          [10, 24, 11, 22] => "Skorpion",
          [11, 23, 12, 22] => "Schütze",
          [12, 23, 12, 31] => "Steinbock"
        }

    zodiacs.each do |key, value|
      date1 = Date.new(self.year, key[0], key[1]) 
      date2 = Date.new(self.year, key[2], key[3])
      if self >= date1 and self <= date2
        return value
      end
    end

	end
	
	def self.month_array(start_date, end_date)
    dates_start = Date.new(start_date.year, start_date.month)
    dates_end   = Date.new(end_date.year, end_date.month)+1.month
    
    dates_array = []
    
    current_date = dates_start
    while current_date < dates_end
      sdate = current_date
      edate = current_date+1.month - 1.second
      
      dates_array << {:start_date => sdate, :end_date => edate}
      
      current_date = current_date +1.month
    end
    return dates_array
	end  
	
	def months_between(date2 = Time.now.to_date, options={:abs => true})
    date1 = self
    abs = 1

    if date1.to_date > date2.to_date
      abs = -1 if options[:abs] == false
      recent_date = date1.to_date
      past_date = date2.to_date
    else
      recent_date = date2.to_date
      past_date = date1.to_date
    end

    return ((recent_date.month - past_date.month) + (12 * (recent_date.year - past_date.year))) * abs
  end
  
  def first_of_month
    Date.new(self.year, self.month)
  end  
  
  def self.end_of_month(date = Date.new(Time.now.year, Time.now.month))
    DateTime.end_of_month(date)
  end
  
  def self.prev_months(i=12)  
    dates = []
    
    i.times do |x|
      dates << Date.new(Time.now.year, Time.now.month)-(i-x).months
    end
    return dates  
  end
  
  def self.this_month
    Date.new(Time.now.year, Time.now.month)
  end
  
  def self.next_month
    self.this_month + 1.month
  end      

end

DateTime.class_eval do
  
  def self.end_of_month(date = Date.new(Time.now.year, Time.now.month))
    date = Date.new(date.year, date.month)
    (date+1.month)-1.second
  end  
  
	def to_german_date
		self.to_de
	end
	
	def to_sql
    self.strftime("%Y-%m-%d %H:%M:%S")
	end  
	
	def months_between(date2 = Time.now.to_date, options={:abs => true})
    self.to_date.months_between(date2, options)
  end
	
	def to_de(options = {})
	  if options[:only_time] == true
	    return self.strftime('%H:%M')
	  else
		  return self.strftime('%d.%m.%Y - %H:%M')
		end
	end
	
	def self.new_from_params(p)
    return DateTime.new(p["starts_at(1i)"].to_i, p["starts_at(2i)"].to_i, p["starts_at(3i)"].to_i, p["starts_at(4i)"].to_i, p["starts_at(5i)"].to_i)
	end  
end

Time.class_eval do
  
  def self.end_of_month(date = Date.new(Time.now.year, Time.now.month))
    DateTime.end_of_month(date)
  end  
  
	def to_german_date
		self.to_datetime.to_de
	end
	
	def to_sql
    self.to_datetime.to_sql
	end  
	
	def to_de(options = {})
	  if options[:only_time] == true
	    return self.strftime('%H:%M')
	  else
		  return self.strftime('%d.%m.%Y - %H:%M')
		end
	end
	
	
end
