# -*- encoding : utf-8 -*-
# Add the methods to the Array Class
module ArrayExt
  Array.class_eval do
  
    # Use sum from Activesupport
    # Sum is not a default in Ruby
    def sum(identity = 0, &block)
      if block_given?
        map(&block).sum(identity)
      else
        inject { |sum, element| sum + element } || identity
      end
    end
  
    # Get avg. value from, either from numeric values or from
    # values from a object included in array
    def avg(attribute = nil)
      @value = self
      if attribute.nil?
        @value.delete(nil)
        @value = self.map {|r| r.to_f }
      else
        @value = self
        # Bei fehlerhaften attribute wird nil gespeichert
        @value = @value.map {|r| r.send(attribute.to_sym).to_f rescue nil}
        # Leere Werte löschen
        @value.delete(nil)
      end
      # Divide by zero ausschliessen
      @value.size == 0 ? size = 1 : size = @value.size
      @value.sum / size
    end
  
  
  
    # Generate a hash with the given array elements as keys and 'init_value' as value
    def array_to_hash(init_val = 0)
      h = {}
      self.each {|x| h.merge!(x => init_val) unless x.nil? }
      return h
    end
  
  
    def to_structured_hash(attribute, options = {})
      data = {}

      self.each do |item|
        if attribute.is_a?(Symbol) && options[:load_from_hash] != true
          key = item.send(attribute) rescue ""
        elsif attribute.is_a?(Symbol) && options[:load_from_hash] == true  
          key = item[attribute] rescue ""
        elsif attribute.is_a?(String)
          attribute_methods = attribute.split(".")  
          key = item.send(attribute_methods[0])
          attribute_methods[1..-1].each do |x|
            key = key.send(x) rescue ""
          end
        end

        if data[key].nil?
          data.merge!(key => [item])
        else
          data[key] << item
        end      
      end

      return data  
    end    

  
    # Sum up an array of objects with given attirbute
    # Attributes can be given as symbol (:my_value will return obj.my_value)
    # or as string ("user.my_value" will return my_value from user object which belongs to object in array)
    # also, options could be passed, which could be *args or options hash
    def sum_with_attribute(arg, opt =nil)
      if arg.nil?
        return self.compact.sum
      else
        values = []
        if arg.is_a?(Symbol)
          self.map {|i| ((opt.nil? ? i.send(arg) : i.send(arg, opt)) rescue 0) }.sum 
        elsif arg.is_a?(String)
          self.each do |v|
            tag_methods = arg.split(".")  
            tagx = v.send(tag_methods[0])
            tag_methods[1..-1].each do |x|
              # Use options if last method in chain called
              if tag_methods[1..-1].last == x && !opt.nil?
                tagx = tagx.send(x,opt)
              else  
                tagx = tagx.send(x)
              end  
            end
            values << tagx  
          end
          return values.compact.sum
        end
      end
    end
  

    # check the number of items included in the array
    def count_for(item)
      count = 0
      self.each {|x| count += 1 if x == item}
      return count
    end
  
  
    # return the item after the given val in array
    # returns val if no item found or val is not included
    # toggle :cycle => true to continue search at beginn of array if end is reached
    def next(val, options = {})
      i = self.index(val)
      return val if i.nil?
      
      i == self.size-1 ?
        (options[:cycle] == true ? self.first : val) : self[i+1] 
    end  
  
  
    # Schnittmenge / Intersection zwischen 2 Arrays
    def isec(b)
      raise ArgumentError, "#{b.inspect} is not an array" if !b.is_a?(Array)
      (self- (self-b))
    end  
  
    # like except for hash
    def except(*args)
      excluded = *args
      return self - excluded
    end  
  
    # break array into n arrays
    def seperate(n = 8)
      @f = n
      aks_size  = self.size
      rest      = aks_size % @f

      @stack = ((aks_size - rest) / @f)

      arrays = (1..@f).to_a

      arrays.map! {|i| self.first(@stack*i).last(@stack) }
      arrays[-1] += self.last(rest) if rest != 0
      #arrays.last.pop if (arrays.last.last.empty? || arrays.last.last.blank?)
      return arrays
    end
  
    # [1,2,3,5,6,7].stack(2)
    #  will return [[1, 2], [3, 5], [6, 7]]
    def stack(n = 4)
      arr = []
      i = (self.size.to_f/n).ceil
      i.times do |x|
        arr << self[x*n..(((x+1)*n)-1)]
      end    
      return arr
    end  
  

    # Prepare array for use with mysql IN operator
    def to_sql
      return "(NULL)" if self.empty?
      if self.first.is_a?(Numeric)
        return "(#{self.join(',')})"
      else
        return "(#{self.map{|i| "'#{i.to_s}'"}.join(',')})"
      end    
    end 
  
    #== Untested / deprecated functions below, should be moved somewhere else!
    # Ignore these functions, there are neither tested nor documented, use them for fun if you like but dont ask me ;-)
  
    def fill_with_sth(sth, size)
      ary_length = self.size
      diff = size - ary_length
      if diff > 0
        pop = Array.new(diff){|i| sth}
        new_ary = pop.push(self).flatten!
        return new_ary
      else
        return self
      end
    end


    # Generiert einen JSON-String aus einem Array mit Werten
    def json_labels
      json = "["
      self.each_with_index {|l,i| json << '{"id": "%s", "text": "%s"}' % [i, l] ; json << "," unless i+1 == self.size}
      json << "]"
    end

    def to_text(sep = "<br />")
      if Rails.env == "development"
        raise "#REMOVED - use .join() - (17.12.2013, 15:18, Florian Eck)"
      else  
        self.join(sep)
      end  
    end  

  end  
end