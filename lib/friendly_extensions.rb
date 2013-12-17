# -*- encoding : utf-8 -*-
# All dit janze zeug laden

require "array"
require "active_record_array"

require "date_n_time"
require "numbers"
require "hash"
require "string_and_more"
require "boolean"

require "object"

require "nil_class"

# SmartCurrency jetzt auch hier (26.03.2013, 16:30, Florian Eck)
require 'smart_currency'

ActiveRecord::Base.send(:include, SmartCurrency) if defined?(ActiveRecord)
