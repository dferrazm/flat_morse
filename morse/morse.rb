require 'yaml'

class Morse
  DEFINITIONS = YAML.load_file('definitions.yml').freeze
  WORD_SEPARATOR = '/'.freeze
  CHAR_SEPARATOR = '|'.freeze
  WHITESPACE = ' '

  def encode(text)
    words = text.split(WHITESPACE)

    encoded_words = words.map do |word|
      encoded_chars = word.chars.map do |char|
        DEFINITIONS[char]
      end.join(CHAR_SEPARATOR)
    end

    encoded_words.join(WORD_SEPARATOR)
  end
end
