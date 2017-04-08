require 'minitest/autorun'
require_relative 'morse'

class TestMorse < Minitest::Test
  def setup
    @morse = Morse.new
  end

  def test_that_the_definitions_are_correctly_encoded
    Morse::DEFINITIONS.each do |char, code|
      assert_equal code, @morse.encode(char)
    end
  end
end
