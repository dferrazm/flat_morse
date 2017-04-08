require 'minitest/autorun'
require_relative 'morse'

class TestMorseEncoder < Minitest::Test
  def test_that_the_definitions_are_correctly_encoded
    definitions = YAML.load_file('definitions.yml')
    definitions.each do |char, code|
      assert_equal code, morse.encode(char)
    end
  end

  def test_encoding_of_hello_world
    assert_equal(
      '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..',
      morse.encode('HELLO WORLD')
    )
  end

  def test_encoding_of_text_containing_all_letters
    assert_equal(
      '-|....|./--.-|..-|..|-.-.|-.-/-...|.-.|---|.--|-./..-.|---|-..-/.---|..-|--|.--.|.../---|...-|.|.-./-|....|./.-..|.-|--..|-.--/-..|---|--.',
      morse.encode('THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG')
    )
  end

  def test_encoding_of_text_containing_all_numbers
    assert_equal(
      '----.|.----|---..|..---|--...|...--|-....|....-|.....',
      morse.encode('918273645')
    )
  end

  def test_encoding_of_text_containing_all_characters
    assert_equal(
      '.----/-|....|./..---/--.-|..-|..|-.-.|-.-/...--/-...|.-.|---|.--|-./....-/..-.|---|-..-/.....|--..--/.---|..-|--|.--.|.../-..../---|...-|.|.-./--.../-|....|./---../.-..|.-|--..|-.--/----./-..|---|--./.----|-----|.-.-.-',
      morse.encode('1 THE 2 QUICK 3 BROWN 4 FOX 5, JUMPS 6 OVER 7 THE 8 LAZY 9 DOG 10.')
    )
  end

  def test_encoding_of_text_with_trailing_spaces
    assert_equal(
      '../.-|--/..|-./-|.-.|---|..-|-...|.-..|.',
      morse.encode('   I AM IN TROUBLE ')
    )
  end

  def test_encoding_of_empty_string
    assert_equal '', morse.encode('')
  end

  def test_encoding_of_null_input
    assert_equal '', morse.encode(nil)
  end

  def test_encoding_of_a_sequence_of_whitespaces
    assert_equal '', morse.encode('   ')
  end

  def test_that_encoding_does_not_care_about_letter_case
    assert_equal(
      '../.-|--/..|-./-|.-.|---|..-|-...|.-..|.',
      morse.encode('I am in Trouble')
    )
  end

  def test_encoding_of_text_with_trailing_spaces
    assert_equal(
      '../.-|--/..|-./-|.-.|---|..-|-...|.-..|.',
      morse.encode('   I AM IN TROUBLE ')
    )
  end

  def test_raise_an_error_when_input_contains_unmapped_characters
    assert_raises Morse::InvalidChar do morse.encode('HELP!') end
  end

  private

  def morse
    @morse ||= Morse::Encoder.new
  end
end
