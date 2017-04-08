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

  def test_encoding_of_hello_world
    assert_equal(
      '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..',
      @morse.encode('HELLO WORLD')
    )
  end

  def test_encoding_of_text_containing_all_letters
    assert_equal(
      '-|....|./--.-|..-|..|-.-.|-.-/-...|.-.|---|.--|-./..-.|---|-..-/.---|..-|--|.--.|.../---|...-|.|.-./-|....|./.-..|.-|--..|-.--/-..|---|--.',
      @morse.encode('THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG')
    )
  end

  def test_encoding_of_text_containing_all_numbers
    assert_equal(
      '----.|.----|---..|..---|--...|...--|-....|....-|.....',
      @morse.encode('918273645')
    )
  end

  def test_encoding_of_text_containing_all_characters
    assert_equal(
      '.----/-|....|./..---/--.-|..-|..|-.-.|-.-/...--/-...|.-.|---|.--|-./....-/..-.|---|-..-/.....|--..--/.---|..-|--|.--.|.../-..../---|...-|.|.-./--.../-|....|./---../.-..|.-|--..|-.--/----./-..|---|--./.----|-----|.-.-.-',
      @morse.encode('1 THE 2 QUICK 3 BROWN 4 FOX 5, JUMPS 6 OVER 7 THE 8 LAZY 9 DOG 10.')
    )
  end
end
