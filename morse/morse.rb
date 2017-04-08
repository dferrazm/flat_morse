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

  class ObfuscatedDefinitions
    def initialize(definitions)
      @definitions = definitions
    end

    def [](char)
      code = @definitions[char]
      obfuscated(code)
    end

    private

    def obfuscated(code)
      obfuscated_sequences(code).join
    end

    def obfuscated_sequences(code)
      char_sequences(code).map do |sequence, type|
        OBFUSCATOR[type].call(sequence)
      end
    end

    # This regex will scan the morse code to find the repeated characters.
    # It returns an array of 2-tuples, the first element being the sequence
    # and second element being the repeated character. Ex:
    # Input: '...--..-'
    # Output: [['...','.'], ['--','-'], ['..','.'],['-','-']]
    def char_sequences(code)
      code.scan(/((.)\2*)/)
    end

    ALPHABET = ('A'..'Z').to_a.freeze
    DOT = '.'.freeze
    DASH = '-'.freeze

    OBFUSCATOR = {
      DOT => ->(dots) { dots.length },
      DASH => ->(dashes) { ALPHABET[dashes.length - 1] }
    }
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
