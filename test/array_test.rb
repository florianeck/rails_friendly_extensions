require "test/unit"
require "array"
require "dummy_class"

class ArrayTest < Test::Unit::TestCase
  
  #== Tests for .sum
  def test_array_should_sum
    assert_equal [1,2].sum, 3
  end  
  
  #== Tests for .avg
  def test_array_avg_with_numbers
    test_array = [4,5]
    
    assert_equal test_array.avg, 4.5
  end  
  
  def test_array_avg_with_attributes
    test_array = []
    test_array << DummyClass.new(:number => 4)
    test_array << DummyClass.new(:number => 5)

    assert_equal test_array.avg(:number), 4.5
  end
  
  def test_array_avg_should_no_break_with_nil_and_emtpy
    assert_equal [3,nil].avg, 3
    assert_equal [].avg, 0
  end  
  
  
  #== Tests for .array_to_hash
  def test_array_should_make_to_hash
    assert_equal [1,2].array_to_hash(""), {1 => "", 2 => ""}
    assert_equal ["A","B"].array_to_hash(1), {"A" => 1, "B" => 1}
    assert_equal ["A",nil].array_to_hash(1), {"A" => 1}
  end  
  
  #== Tests for .to_structured_hash
  def test_array_should_get_structured_with_symbol_and_nested_string
    
    # Create Test Datas
    test_data_row = []
    test_data_row << DummyClass.new(:sec_id => 1, :name => "bla-1")
    test_data_row << DummyClass.new(:sec_id => 1, :name => "bla-2")
    test_data_row << DummyClass.new(:sec_id => 1, :name => "bla-3")
    
    test_data_row << DummyClass.new(:sec_id => 2, :name => "blub-1")
    test_data_row << DummyClass.new(:sec_id => 2, :name => "blub-2")
    
    test_data_hash_sym = test_data_row.to_structured_hash(:sec_id)
    test_data_hash_str = test_data_row.to_structured_hash("return_self.sec_id")
    
    # Assertions
    assert_equal test_data_hash_sym.keys.size, 2
    assert_equal test_data_hash_sym[1].size, 3
    assert_equal test_data_hash_sym[2].size, 2
    
    assert_equal test_data_hash_sym, test_data_hash_str
  end
  
  #== Tests for .sum_with_attribute
  def test_array_should_do_sum_with_attributes
    
    test_array = []
    test_array << DummyClass.new(:number => 4)
    test_array << DummyClass.new(:number => 5)
      
    # Using symbol  
    assert_equal test_array.sum_with_attribute(:number), 9
    
    # Using nested string
    assert_equal test_array.sum_with_attribute("return_self.number"), 9
    
    # Using symbol with options
    assert_equal test_array.sum_with_attribute(:get_number, :double => true), 18
    
    # Using nested string with options
    assert_equal test_array.sum_with_attribute("return_self.get_number", :double => true), 18
  end
  
  #== Tests for .count_for
  def test_array_should_count_for_items
    a1 = [1,2,3]
    
    assert_equal a1.count_for(1), 1
    
    a2 = %w(a a b c)
    assert_equal a2.count_for("a"), 2
    
    a3 = %w(a b c)
    assert_equal a3.count_for("x"), 0
    
    a4 = [1,:a, nil]
    assert_equal a4.count_for(nil), 1
  end  
  
  #== Tests for .next
  def test_get_next_array_item_without_cycle
    a = [1,2,3]
    assert_equal a.next(2), 3
    assert_equal a.next(3), 3
    assert_equal a.next(4), 4
    
    
  end
  
  def test_get_next_array_item_with_cycle
    a = [1,2,3]
    assert_equal a.next(3, :cycle => true), 1
    assert_equal a.next(1, :cycle => true), 2
  end
  
  #== Tests for .isec
  def test_array_must_isec_with_array
    assert_raises ArgumentError do
      [1,2,3].isec(3)
    end  
  end
  
  def test_array_isec
    a1 = %w(a b c d)
    a2 = %w(c d e f)
    a3 = %w(a f x y)
    a4 = %w(1 2 3 4)
    
    assert_equal a1.isec(a2), %w(c d)
    assert_equal (a1+a2).isec(a3), %w(a f)
    assert_equal a3.isec(a4), []
  end
  
  #== Tests for .except
  def test_array_except
    a = [1,2,3, "a", "b"]
    assert_equal a.except(1), [2,3, "a", "b"]
    assert_equal a.except(1,2), [3, "a", "b"]
    assert_equal a.except(1,"a"), [2,3, "b"]
  end 
  
  #== Tests for .seperate
  def test_array_seperation
    {4 => (1..10).to_a, 25 => (1..100).to_a}.each do |n, array|
      
      sep_array = array.seperate(n)
      
      assert_equal sep_array.size, n
      assert_equal sep_array.flatten, array
    end  
  end
  
  def test_array_should_seperate__arrays_correctly
    # Fix for:
    # [[1, "a"], [2, "b"], [3, "c"]].seperate(2).last
    # => [[2, "b"], [[3, "c"]]] - Last Array is in an other array
    
    assert_equal [[1, "a"], [2, "b"], [3, "c"]].seperate(2).last.last, [3,"c"]
    assert_equal [[1, "a"], [2, "b"], [3, "c"], [4, "d"]].seperate(2).last.last, [4,"d"]
    
  end  
  
  #== Tests for .stack
  def test_array_stack
    {4 => (1..10).to_a, 25 => (1..100).to_a}.each do |n, array|
      
      sep_array = array.stack(n)
      
      assert_equal sep_array.first.size, n
      assert_equal sep_array.flatten, array
    end  
  end 
  
  #== Tests for .to_sql
  def test_array_to_sql
    # Empty array is NULL
    assert_equal [].to_sql, "(NULL)"
    
    # Numbers should be unquoted
    a = [1,2,4.5]
    assert_no_match Regexp.new("'"), a.to_sql
    assert_equal a.to_sql, "(1,2,4.5)"
    
    # All others should be unquoted
    a = ["a", :b]
    assert_match Regexp.new("'"), a.to_sql
    assert_equal a.to_sql, "('a','b')"
  end         
  
  
  
end  