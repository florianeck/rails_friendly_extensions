require "test/unit"
require "hash"

class HashTest < Test::Unit::TestCase
  
  #== Test for .ordered
  def test_hash_should_get_ordered
    
    test_hash = {
      1 => "a", 2 => "b", 3 => "c"
    }
    
    # Test options with sym or integer
    assert_equal test_hash.ordered(:key), test_hash.ordered(0)
    assert_equal test_hash.ordered(:value), test_hash.ordered(1)
    assert_equal test_hash.ordered(0), test_hash.ordered(1)
    
    test_hash = {
      1 => "z", 2 => "y", 3 => "x"
    }
    
    assert_equal test_hash.ordered(:key).map {|r| r[0]}, [1,2,3]
    assert_equal test_hash.ordered(:value).map {|r| r[0]}, [3,2,1]
    
  end  
  
  #== Test for .extract_data
  def test_hash_should_extract_data
    
    # It should work with symbol and string as keys:
    test_hash = {
      "field_1" => 1, "field_2" => 0, :field_3 => 1
    }
    
    # default trigger is "1", so nothing should happen now
    assert_equal test_hash.extract_data, [] 
    
    # Using trigger = 1 should work
    assert_equal test_hash.extract_data(nil, 1), ["field_1", "field_3"] 
    
    # Now using slice and trigger
    assert_equal test_hash.extract_data("field_", 1), ["1", "3"] 
      
  end  
  
end  
