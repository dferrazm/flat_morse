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
      @text = (text || '').upcase
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
      chars.map { |char| encoded_char(char) }
    end

    def encoded_char(char)
      DEFINITIONS[char] || raise_error(char)
    end

    def raise_error(char)
      raise InvalidChar.new(char)
    end
  end

  class InvalidChar < StandardError
    def initialize(char)
      super("Character '#{char}' is unmapped")
    end
  end
end
