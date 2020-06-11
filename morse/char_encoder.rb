module Morse
  ##
  # Responsible to encode a given string character.
  class CharEncoder
    def initialize(definitions)
      @definitions = definitions
    end

    def encoded(char)
      @definitions.code(char)
    end
  end
end
