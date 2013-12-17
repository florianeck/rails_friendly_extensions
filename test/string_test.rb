require "test/unit"
require "string_and_more"

class StringTest < Test::Unit::TestCase
  
  #== Test for String.random_string
  def test_string_should_create_random_string
    n = rand(25)
    [:upcase, :downcase, :numbers, :all].each do |mode|
      
      s = String.random_string(n,mode)
      assert_equal s.size, n 

      if mode != :all
        assert_no_match Regexp.new("[^#{RANDOM_CHARS[mode]}]"), s
      end  
    end  
  end
  
    
  
  
end  