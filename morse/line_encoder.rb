module Morse
  ##
  # Responsible to encode a single line string, i.e.,
  # a set of words in a single file not containing any line break.
  class LineEncoder
    def initialize(definitions)
      @word_encoder = WordEncoder.new(definitions)
    end

    def encoded(line)
      encoded_words(line.words).join(WORD_SEPARATOR)
    end

    private

    def encoded_words(words)
      words.map { |word| @word_encoder.encoded(word) }
    end
  end
end
