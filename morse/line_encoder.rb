module Morse
  ##
  # Responsible to encode a single line string, i.e.,
  # a set of words in a single file not containing any line break.
  class LineEncoder < BaseEncoder
    def initialize(definitions)
      @word_encoder = WordEncoder.new(definitions)
    end

    def encoded(line)
      @word_encoder.encoded_multiple(line.words).join(WORD_SEPARATOR)
    end
  end
end
