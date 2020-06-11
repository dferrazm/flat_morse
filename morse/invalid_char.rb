module Morse
  ##
  # Error raised when there's no mapping for a provided char,
  # i.e. a Morse code definition is missing.
  class InvalidChar < StandardError
    def initialize(char)
      super("Character '#{char}' is unmapped")
    end
  end
end
