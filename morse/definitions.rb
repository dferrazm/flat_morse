module Morse
  ##
  # Class that wraps the characters code definitions. It receives
  # a hash that maps each character that can be encoded to its target Morse code.
  # With that, each mapped character can be encoded calling the `code` method.
  # Example:
  #
  #   defintions = Definitions.new({ 'a' => '.-', 'b' => '-...' })
  #   defintions.code('a') # => '.-'
  #   defintions.code('b') # => '-...'
  #   defintions.code('c') # => raise +InvalidChar+
  #
  class Definitions
    def initialize(code_map)
      @code_map = code_map
    end

    def code(char)
      @code_map[char.upcase] || raise_error(char)
    end

    private

    def raise_error(char)
      raise InvalidChar.new(char)
    end
  end
end
