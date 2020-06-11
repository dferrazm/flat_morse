module Morse
  ##
  # Represents an obfuscated set of Morse code definitions. It decorates
  # a Definitions instance to return the resultant Morse code obfuscated,
  # for a given character. The obfuscation happens in the following manner:
  #
  # - It replaces each sequence of dots with a number correnponding to the
  #   length of the sequence.
  # - It replaces each sequence of dashes with the letter in the alphabet (A...Z),
  #   grabbed by a given position, where the position corresponds the length of
  #   the sequence
  #
  # Example:
  #
  #   defintions = Definitions.new({ 'b' => '-...', 'j' => '.---' })
  #   obuscated = DefinitionsObfuscated.new(definitions)
  #   obfuscated.code('b') # => 'A3'
  #   obfuscated.code('j') # => '1C'
  #   obfuscated.code('c') # => raise +InvalidChar+
  #
  class DefinitionsObfuscated
    ALPHABET = ('A'..'Z').to_a.freeze
    DOT = '.'.freeze
    DASH = '-'.freeze

    OBFUSCATOR = {
      DOT => ->(dots_sequence) { dots_sequence.length },
      DASH => ->(dashes_sequence) { ALPHABET[dashes_sequence.length - 1] }
    }.freeze

    def initialize(definitions)
      @definitions = definitions
    end

    def code(char)
      obfuscated(@definitions.code(char))
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
  end
end
