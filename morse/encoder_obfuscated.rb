module Morse
  ##
  # Represents an Obfuscated Morse encoder. See +DefinitionsObfuscated+
  # for more info. Example:
  #
  #   encoder = Morse::EncoderObuscated.new(definitions)
  #   encoder.encode_text('HELLO WORLD')  # => '4|1|1A2|1A2|C/1B|C|1A1|1A2|A2'
  #   encoder.encode_file('path/to/file') # => '4|1|1A2|1A2|C/1B|C|1A1|1A2|A2'
  #
  class EncoderObfuscated
    extend Forwardable

    def initialize(definitions = DEFINITIONS)
      @wrapped_encoder = Encoder.new(
        DefinitionsObfuscated.new(definitions)
      )
    end

    def_delegators :@wrapped_encoder, :encode_text, :encode_file
  end
end
