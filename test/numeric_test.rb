require "test/unit"
require "numbers"


class NumericTest < Test::Unit::TestCase

  
  def test_number_to_euro
    #assert_equal 0.29.to_euro, "0,29"
  end
  
  # Test Math Functions  
  def test_math_infla_defla
    
    [2, 3.3].each do |f|
      [40,250].each do |n|
        i = 500
        r_inf = r_def = i
      
        n.times do |i|
          r_inf = r_inf*(1+f/100.0) 
          r_def = r_def*(1-f/100.0) 
        end  
      
        assert_equal i.infla(n,f).round(5), r_inf.round(5)
        assert_equal i.defla(n,f).round(5), r_def.round(5)
      end  
    end  
    
  end  
  
  def test_number_should_get_closest
    # Test for wrong limit mode:
    assert_raise ArgumentError do 
      1.get_closest([3,4], :zonk)
    end
    
    # Check to find closest
    assert_equal 2.get_closest([0,3,4], :ceil),       3  
    assert_equal 2.get_closest([0,3,4], :floor),      3  
    assert_equal -2.88.get_closest([0,3,4], :floor),  0  
    
    # Check to find closest with :floor
    assert_equal 1.get_closest([0,2], :floor), 0  
    assert_equal 5.5.get_closest([4.5,6.5], :floor), 4.5  
    
    # Check to find closest with :ceil
    assert_equal 1.get_closest([0,2], :ceil), 2
    assert_equal 5.5.get_closest([4.5,6.5], :ceil), 6.5    
    
  end  
  
  
  def test_numbers_min_and_max
    assert_equal 1, 1.min(3)
    assert_equal 3, 1.max(3)
    assert_equal 2, 2.min_max(1,3)
    assert_equal 1, -1.min_max(1,3)
    assert_equal 3, 4.min_max(1,3)
  end 
  
  def test_float_dividor
    assert !1.fdiv(1).is_a?(Integer)
  end
  
  def test_to_q_faktor
    assert_equal 2.to_q, 1.02
  end 
  
  def test_time_should_be_calc_correct
    assert_equal 23.to_time,    "00:00:23"
    assert_equal 64.to_time,    "00:01:04"
    
    assert_equal 17.to_time(:discard_hour => true),    "00:17"
    assert_equal 73.to_time(:discard_hour => true),    "01:13"
    
    assert_equal 3672.to_time,  "01:01:12"
  end      

end  