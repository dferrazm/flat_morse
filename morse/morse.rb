require 'yaml'

class Morse
  DEFINITIONS = YAML.load_file('definitions.yml').freeze
  WORD_SEPARATOR = '/'.freeze
  CHAR_SEPARATOR = '|'.freeze

  def encode(text)
    InputText.new(text).encoded
  end

  class InputText
    def initialize(text)
      @text = text
    end

    def encoded
      encoded_words.join(WORD_SEPARATOR)
    end

    private

    def words
      @text.split(' ')
    end

    def encoded_words
      words.map { |word| encoded_word(word) }
    end

    def encoded_word(word)
      encoded_chars(word.chars).join(CHAR_SEPARATOR)
    end

    def encoded_chars(chars)
      chars.map do |char|
        DEFINITIONS[char]
      end
    end
  end
end
