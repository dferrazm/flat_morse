module Morse
  ##
  # Responsible to encode a single word string, i.e.,
  # a set of chars in a single word not containing any spaces.
  class WordEncoder
    def initialize(word, definitions = DEFINITIONS)
      @word = word
      @definitions = definitions
    end

    def encoded
      encoded_chars.join(CHAR_SEPARATOR)
    end

    private

    def encoded_chars
      chars.map { |char| @definitions.code(char) }
    end

    def chars
      @word.chars
    end
  end
end
