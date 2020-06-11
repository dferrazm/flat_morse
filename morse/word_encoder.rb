module Morse
  ##
  # Responsible to encode a single word string, i.e.,
  # a set of chars in a single word not containing any spaces.
  class WordEncoder < BaseEncoder
    def initialize(definitions)
      @char_encoder = CharEncoder.new(definitions)
    end

    def encoded(word)
      @char_encoder.encoded_multiple(word.chars).join(CHAR_SEPARATOR)
    end
  end
end
