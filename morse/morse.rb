require 'yaml'

module Morse
  class Definitions
    def initialize(chars_map)
      @chars_map = chars_map
    end

    def [](char)
      @chars_map[char.upcase] || raise_error(char)
    end

    private

    def raise_error(char)
      raise InvalidChar.new(char)
    end
  end

  DEFINITIONS = Definitions.new(YAML.load_file('definitions.yml')).freeze
  WORD_SEPARATOR = '/'.freeze
  CHAR_SEPARATOR = '|'.freeze

  class Encoder
    def initialize(definitions = DEFINITIONS)
      @definitions = definitions
    end

    def encode(text)
      InputText.new(text, @definitions).encoded
    end
  end

  class InputText
    def initialize(text, definitions = DEFINTIONS)
      @text = text || ''
      @definitions = definitions
    end

    def encoded
      encoded_words.join(WORD_SEPARATOR)
    end

    private

    def encoded_words
      words.map do |word|
        InputWord.new(word, @definitions).encoded
      end
    end

    def words
      @text.split(' ')
    end
  end

  class InputWord
    def initialize(word, definitions = DEFINITIONS)
      @word = word
      @definitions = definitions
    end

    def encoded
      encoded_chars.join(CHAR_SEPARATOR)
    end

    private

    def encoded_chars
      chars.map { |char| @definitions[char] }
    end

    def chars
      @word.chars
    end
  end

  class InvalidChar < StandardError
    def initialize(char)
      super("Character '#{char}' is unmapped")
    end
  end
end
