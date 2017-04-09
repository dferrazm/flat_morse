require 'minitest/autorun'
require_relative 'flatten'

class TestFlatArray < Minitest::Test
  def test_flattening_a_null_array
    assert_equal [], flatten(nil)
  end

  def test_flattening_an_empty_array
    assert_equal [], flatten([])
  end

  def test_flattening_an_already_flattened_array
    assert_equal [1, 2, 3], flatten([1, 2, 3])
  end

  def test_flattening_1_level_nested_arrays
    assert_equal [1, 2, 3], flatten([1, [2, 3]])
    assert_equal [1, 2, 3, 4], flatten([1, [2, 3], 4])
    assert_equal [1, 2, 3, 4], flatten([[1, 2, 3], 4])
    assert_equal [1, 2, 3, 4], flatten([1, [2], [3], 4])
  end

  def test_flattening_2_level_nested_arrays
    assert_equal [1, 2, 3], flatten([1, [2, [3]]])
    assert_equal [1, 2, 3, 4], flatten([1, [[2, 3]], 4])
    assert_equal [1, 2, 3, 4], flatten([[1, [2], 3], 4])
    assert_equal [1, 2, 3, 4], flatten([1, [[2]], [3], 4])
  end

  def test_flattening_3_level_nested_arrays
    assert_equal [1, 2, 3], flatten([1, [2, [[3]]]])
    assert_equal [1, 2, 3, 4], flatten([1, [[[2], 3]], 4])
    assert_equal [1, 2, 3, 4], flatten([[1, [[2]], 3], 4])
    assert_equal [1, 2, 3, 4], flatten([1, [[[2]]], [3], 4])
  end

  def test_flattening_complex_nested_arrays
    assert_equal [1, 2, 3, 4, 5, 6, 7, 8], flatten([[1], [[2], [[3]], [[[4], 5]]], [6, 7], 8])
  end

  def test_flattening_an_array_that_contain_elems_other_than_numbers
    assert_raises RuntimeError do flatten([1, '2', 3]) end
  end
end
