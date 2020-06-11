module Morse
  # Responsible to encode a single line string, i.e.,
  # a set of words in a single file not containing any line break.
  class LineEncoder
    def initialize(line, definitions = DEFINTIONS)
      @line = line
      @definitions = definitions
    end

    def encoded
      encoded_words.join(WORD_SEPARATOR)
    end

    private

    def encoded_words
      words.map { |word| word_encoder(word).encoded }
    end

    def words
      @line.split(' ')
    end

    def word_encoder(word)
      WordEncoder.new(word, @definitions)
    end
  end
end
