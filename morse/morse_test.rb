require 'minitest/autorun'
require_relative 'morse'

# NOTE: The following tests are excercising only the `Morse::Encoder` because that's
# the intended interface that clients of this class will make use. As all the other
# classes are being used under the hood, they are being tested as well. But of course,
# to achieve a more granular unit testing, these classes could also be easily
# unit tested, should that be required.

class TestMorseEncoder < Minitest::Test
  def test_that_the_definitions_are_correctly_encoded
    definitions = YAML.load_file('definitions.yml')
    definitions.each do |char, code|
      assert_equal code, morse.encode_text(char)
    end
  end

  def test_encoding_of_hello_world
    assert_equal(
      '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..',
      morse.encode_text('HELLO WORLD')
    )
  end

  def test_encoding_of_text_containing_all_letters
    assert_equal(
      '-|....|./--.-|..-|..|-.-.|-.-/-...|.-.|---|.--|-./..-.|---|-..-/.---|..-|--|.--.|.../---|...-|.|.-./-|....|./.-..|.-|--..|-.--/-..|---|--.',
      morse.encode_text('THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG')
    )
  end

  def test_encoding_of_text_containing_all_numbers
    assert_equal(
      '----.|.----|---..|..---|--...|...--|-....|....-|.....',
      morse.encode_text('918273645')
    )
  end

  def test_encoding_of_text_containing_all_characters
    assert_equal(
      '.----/-|....|./..---/--.-|..-|..|-.-.|-.-/...--/-...|.-.|---|.--|-./....-/..-.|---|-..-/.....|--..--/.---|..-|--|.--.|.../-..../---|...-|.|.-./--.../-|....|./---../.-..|.-|--..|-.--/----./-..|---|--./.----|-----|.-.-.-',
      morse.encode_text('1 THE 2 QUICK 3 BROWN 4 FOX 5, JUMPS 6 OVER 7 THE 8 LAZY 9 DOG 10.')
    )
  end

  def test_encoding_of_text_with_trailing_spaces
    assert_equal(
      '../.-|--/..|-./-|.-.|---|..-|-...|.-..|.',
      morse.encode_text('   I AM IN TROUBLE ')
    )
  end

  def test_encoding_of_text_with_line_breaks
    assert_equal(
      "../.-|--/..|-.\n-|.-.|---|..-|-...|.-..|.",
      morse.encode_text("I AM IN\nTROUBLE")
    )
  end

  def test_encoding_of_empty_string
    assert_equal '', morse.encode_text('')
  end

  def test_encoding_of_null_input
    assert_equal '', morse.encode_text(nil)
  end

  def test_encoding_of_a_sequence_of_whitespaces
    assert_equal '', morse.encode_text('   ')
  end

  def test_that_encoding_does_not_care_about_letter_case
    assert_equal(
      '../.-|--/..|-./-|.-.|---|..-|-...|.-..|.',
      morse.encode_text('I am in Trouble')
    )
  end

  def test_raise_an_error_when_input_contains_unmapped_characters
    assert_raises Morse::InvalidChar do morse.encode_text('HELP!') end
  end

  private

  def morse
    @morse ||= Morse::Encoder.new
  end
end

class TestObfuscatedMorseEncoder < Minitest::Test
  def test_obfuscation
    assert_equal(
      '2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1',
      morse.encode_text('I AM IN TROUBLE')
    )
  end

  def test_encoding_of_text_containing_all_characters
    assert_equal(
      '1D/A|4|1/2C/B1A|2A|2|A1A1|A1A/3B/A3|1A1|C|1B|A1/4A/2A1|C|A2A/5|B2B/1C|2A|B|1B1|3/A4/C|3A|1|1A1/B3/A|4|1/C2/1A2|1A|B2|A1B/D1/A2|C|B1/1D|E|1A1A1A',
      morse.encode_text('1 THE 2 QUICK 3 BROWN 4 FOX 5, JUMPS 6 OVER 7 THE 8 LAZY 9 DOG 10.')
    )
  end

  def test_encoding_of_text_with_trailing_spaces
    assert_equal(
      '2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1',
      morse.encode_text('   I AM IN TROUBLE ')
    )
  end

  def test_encoding_of_empty_string
    assert_equal '', morse.encode_text('')
  end

  def test_encoding_of_null_input
    assert_equal '', morse.encode_text(nil)
  end

  def test_encoding_of_a_sequence_of_whitespaces
    assert_equal '', morse.encode_text('   ')
  end

  def test_that_encoding_does_not_care_about_letter_case
    assert_equal(
      '2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1',
      morse.encode_text('I am in Trouble')
    )
  end

  def test_raise_an_error_when_input_contains_unmapped_characters
    assert_raises Morse::InvalidChar do morse.encode_text('HELP!') end
  end

  def test_encoding_of_a_file_that_has_valid_content
    test_file = 'test_file.valid'
    encoded_file = morse.encode_file(test_file)

    assert File.exist?(encoded_file)
    assert_equal "#{test_file}.encoded", File.basename(encoded_file)

    encoded_content = File.read(encoded_file).strip
    assert_equal "4|1|1A2|1A2|C/1B|C|1A1|1A2|A2\n2/1A|B/2|A1/A|1A1|C|2A|A3|1A2|1", encoded_content
  end

  def test_encoding_of_a_file_that_has_invalid_content
    test_file = 'test_file.invalid'
    assert_raises Morse::InvalidChar do morse.encode_file(test_file) end

    encoded_file = "#{test_file}.encoded"
    assert !File.exist?(encoded_file)
  end

  private

  def morse
    @obfuscated_morse ||= Morse::Encoder.new(Morse::OBFUSCATED_DEFINITIONS)
  end
end
