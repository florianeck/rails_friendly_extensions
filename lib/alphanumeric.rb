# -*- encoding : utf-8 -*-
module Alphanumeric
  
  # Give every year a letter
  # TODO: should be automatically computed
  LETTERS = "abcdefghijklmnopqrstuvwxyz".upcase.split('')
  
  START_YEAR = 1960
  
  YEAR_LETTERS = {
    2009 => "A",
    2010 => "B",
    2011 => "C",
    2012 => "D",
    2013 => "E",
    2014 => "F",
    2015 => "G",
    2016 => "H",
    2017 => "I",
    2018 => "J",
    2019 => "K",
    2020 => "L",
    2021 => "M",
    2022 => "N",
    2023 => "O",
    2024 => "P",
    2025 => "Q",
    2026 => "R",
    2027 => "S",
    2028 => "T",
    2029 => "U",
    2030 => "V",
    2031 => "W",
    2032 => "X",
    2033 => "Y",
    2034 => "Z",
    2035 => "AA",
    2036 => "BA",
    2037 => "CA",
    2038 => "DA",
    2039 => "EA",
    2040 => "FA",
    2041 => "GA",
    2042 => "HA",
    2043 => "IA",
    2044 => "JA",
    2045 => "KA",
    2046 => "LA",
    2047 => "MA",
    2048 => "NA",
    2049 => "OA",
    2050 => "PA",
  }
  
  def self.year_letter(year=Time.now.year, letters = LETTERS)
    
    steps = []
    
    d = (year - START_YEAR)
    n = d.fdiv(letters.size).ceil
    string = ""
    
    n.times do |i| 
      # First 
      if i == 0
        string << letters[d%letters.size]
      else
        x = d.fdiv(letters.size*(i+1)).round
        string << letters[x]
      end    
    end  
    
    return string
  end  

end  
