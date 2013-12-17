require "test/unit"
require "string_and_more"
require "date"
class StringTest < Test::Unit::TestCase
  
  #== Test for String.random_string
  def test_string_should_create_random_string
    n = rand(25)
    [:upcase, :downcase, :numbers, :all].each do |mode|
      
      s = String.random_string(n,mode)
      assert_equal s.size, n 

      if mode != :all
        assert_no_match Regexp.new("[^#{String::RANDOM_CHARS[mode]}]"), s
      end  
    end  
  end
  
  #== Test for .to_boolean
  def test_string_should_convert_into_boolean
    ['true', 'True', 'TRUE', '1'].each do |x|
      assert x.to_boolean
    end
    assert !"false".to_boolean  
  end
  
  #== Test for .to_date
  def test_string_should_convert_to_date
    
    ["44.12.2013", "37.12.2012", "1.12.2012", "21.1.2012"].each do |d|
      assert_raise ArgumentError do 
        d.to_date 
      end
    end  
    
    assert_equal Date.new(2012,1,1), "01.01.2012".to_date    
    assert_equal Date.new(2012,12,27), "27.12.2012".to_date    
      
  end  
  
  
end  