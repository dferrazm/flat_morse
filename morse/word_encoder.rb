module Morse
  ##
  # Responsible to encode a single word string, i.e.,
  # a set of chars in a single word not containing any spaces.
  class WordEncoder
    def initialize(definitions)
      @char_encoder = CharEncoder.new(definitions)
    end

    def encoded(word)
      encoded_chars(word.chars).join(CHAR_SEPARATOR)
    end

    private

    def encoded_chars(chars)
      chars.map { |char| @char_encoder.encoded(char)  }
    end
  end
end
