# -*- encoding : utf-8 -*-
module StringAndMore
  String.class_eval do
  
    require "chars_2_remove"
    require 'digest/sha1'
    
    # List with internation chars and their ASCII replacement
    CHARS_TO_REMOVE = Chars2Remove::CHARS
    
    # Characters for creating randdom char combinations
    String::RANDOM_CHARS = {:upcase => "ABCDEFGHIJKLMNOPQRSTUVWXYZ", :downcase => "abcdefghijklmnopqrstuvwxyz", :numbers => "1234567890"}
    
    # String charsets used for numeric encryption
    STRING_CHARSETS = {
      "a" => String::RANDOM_CHARS[:upcase],
      "A" => String::RANDOM_CHARS[:downcase],
      "1" => String::RANDOM_CHARS[:numbers],
      "ä" => "äöüÄÖÜß",
      "!" => '!\"§$%&/()=?+*#@,.-;:_\' ¡“”¶¢[]|{}≠¿^°≤≥∞…–‘’<>'
    }
    
    # Array with all strings which can be encrypted
    STRING_BASE = STRING_CHARSETS.values.join("")
  
    # Returns random String, for Passwords, Captachs etc..
    # could create :upcase, :downcase, :numbers or :all
    def self.random_string(l=12, mode = :all)
      case mode
      when :all
        base = String::RANDOM_CHARS.values.join("").split("")
      else
        base = String::RANDOM_CHARS[mode].split("")
      end
    
      str = ""
    
      l.times do 
        str <<  base.shuffle[rand(base.size-1)]
      end    
      return str
    end
    
    def self.email_message_id(mail_domain)
      "<#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{mail_domain}>"
    end  
  
  
    # Extract boolean status from string
    def to_boolean
      if ['true', 'True', 'TRUE', '1'].include?(self)
        return true
      else
        return false
      end
    end
  
    # Create string with german date format to Date
  	def to_date
      # Try German
      matched_date = self.match(/((0|1|2|3)[0-9]{1})\.(0[0-9]{1}|10|11|12)\.[0-9]{4}/)
      
      if !matched_date.nil?
        return Date.new(matched_date.to_s.split(".")[2].to_i, matched_date.to_s.split(".")[1].to_i, matched_date.to_s.split(".")[0].to_i)
      elsif matched_date.nil?
        matched_date = self.match(/[0-9]{4}-(0[0-9]{1}|10|11|12)-((0|1|2|3)[0-9]{1})/)
        if !matched_date.nil?
          return Date.new(matched_date.to_s.split("-")[0].to_i, matched_date.to_s.split("-")[1].to_i, matched_date.to_s.split("-")[2].to_i)
        end  
      end 
       
      raise ArgumentError, "String has no date like DD.MM.YYYY or YYYY-DD-MM" if matched_date.nil?
  	end
    
    
    def to_number(type = :float)
      extract = self.match(/[0-9\.,]{1,}/).to_s
      final = extract.gsub(".", "").gsub(",", ".")
      case type 
      when :float
        return final.to_f
      else
        return final.to_i
      end    
    end  
  
    def to_label(options = {:show_tooltip => false})
      if FriendsLabel.table_exists?
        l = FriendsLabel::LABELS[self]
        if l.nil? 
          FriendsLabel.create(:label => self, :attribute_name => self)
          return self
        else  
          unless options[:show_tooltip] == true
            return l[:label]
          else
            return l[:tooltip]
          end
        end  
      else
        return self
      end    
    end
    
    def shuffle
      self.split("").sort_by {rand}.join.humanize
    end  
  
  
    def to_foldername(sep = "_")
      # deutsch umlaute ersetzen
      parameterized_string = self.strip.gsub(/\ {2,}/ , " ").de_2_int
    
      # Turn unwanted chars into the separator
      parameterized_string.gsub!(/[^a-zA-Z0-9ÄÖÜöäüß\-_]+/, sep)
      unless sep.nil? || sep.empty?
        re_sep = Regexp.escape(sep)
        # No more than one of the separator in a row.
        parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
        # Remove leading/trailing separator.
        parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/, '')
      end
      return parameterized_string
    end
  
  
  
    def de_2_int
      str = self
      CHARS_TO_REMOVE.each do |de, int|
        str = str.gsub(de, int)
      end
      str = str.gsub("  ", " ")
      return str  
    end
	
  	def limit(l=20)
  	  if self.size > l
  	    s = self.size
  	    s2 = (((self.size-1)/2).round)
  	    first = self.slice(0..s2)
        last  = self.slice(s2+1..-1)
      
        l1 = (l/2).round
      
  	    "#{first.first(l1)}...#{last.last(l1)}"
  	  else
  	    return self
  	  end    
  	end  
	
	
	
	
  	def to_datetime
  	  date  = self.split(" ").first
  	  time  = self.split(" ").last.split(":")
  	  DateTime.new(date.split(".")[2].to_i, date.split(".")[1].to_i, date.split(".")[0].to_i, time.first.to_i, time.last.to_i)
  	end  
	
	
  	def clear_html(options = {})
  	  ActionView::Base.full_sanitizer.sanitize(self, :tags => options[:tags] )
  	end
  
  	def replace_html(from, to)
  	  new_text = self
  	  new_text = new_text.gsub("<#{from}>", "<#{to}>")
      new_text = new_text.gsub("</#{from}>", "</#{to}>")
      return new_text
  	end    
	
  	def to_model
      self.singularize.camelize.constantize
  	end  
	
  	def to_a
  	  return [self]
  	end  
	
  	#== HTML Styling
    # as the function names say
    
  	def bold
      "<b>#{self}</b>".html_safe
  	end
	
  	def ital
      "<i>#{self}</i>".html_safe
  	end
	
  	def span
      "<span>#{self}</span>".html_safe
  	end
	
  	def uline
      "<u>#{self}</u>".html_safe
  	end  
	
    def nbsp
      self.gsub(" ", "&nbsp;").html_safe
    end  
  
  	def replace_entities(mode = :html, options = {})
  	  str = self
  	  Chars2Remove::ENTITIES.each do |orig, rep|
  	     str = str.gsub(orig, rep[mode])
  	  end
  	  return str.html_safe  
  	end
	
  	def add_brs
  	  return self.gsub("\n", "<br />")
  	end    
	
  	#== colorization in console
    
      def colorize(color_code)
        "\e[#{color_code};40m#{self}\e[0m"
      end

      def red
        colorize(31)
      end

      def green
        colorize(32)
      end

      def yellow
        colorize(33)
      end

      def pink
        colorize(35)
      end
	
   
   #== Numerische encription
   # cool thing for simple encrypt and decrypt strings
   
   def numberize(options = {})
     # Basisarray das alle zeichen enthält die verschlüsselt werden können
     string_array = STRING_BASE.split("")
   
     # Nur Zahlen und buchstaben für die verschlüsselung/mix nehmen wg. URLs
     string_array_filtered = string_array.select {|s| !s.match(/[a-zA-Z0-9\-_]/).nil? }
     splitted = self.split("")

     numbered_string = ""

     splitted.each do |s|
       position = string_array.index(s)
       if !position.nil?
         numbered_string << (position.to_s.rjust(2, "0")+string_array_filtered[rand(string_array_filtered.size-1)])
       end  
     end

     return options[:base_64] == true ? Base64.encode64(numbered_string) : numbered_string  
   end  
	
   def denumberize(options = {})
     string_array = STRING_BASE.split("")
     real_string = ""
     (options[:base_64] == true ? Base64.decode64(self) : self  ).scan(/[0-9]{2}.{1}/).each do |s|
       real_string << string_array[s.first(2).to_i]
     end
     return real_string  
   end  
  
      
	
  end

  Symbol.class_eval do

    def to_label(options = {})
      self.to_s.to_label(options)
    end
    
    def gsub(old, repl)  
      self.to_s.gsub(old, repl)
    end  
  end  
end