module Morse
  ##
  # Represents a Morse encoder that, provided a set of definitions,
  # encodes plain text strings or files contents. Every encoded character
  # is separated with a '|' (pipe char) and every word is separated with a
  # forward '/' (forward slash). It also does not care about letter case.
  # Example:
  #
  #   encoder = Encoder.new(definitions)
  #   encoder.encode_text('HELLO WORLD')  # => '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..'
  #   encoder.encode_file('path/to/file') # => '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..'
  #
  #   encoder = Encoder.new(obfuscated_definitions)
  #   encoder.encode_text('HELLO WORLD')  # => '4|1|1A2|1A2|C/1B|C|1A1|1A2|A2'
  #   encoder.encode_file('path/to/file') # => '4|1|1A2|1A2|C/1B|C|1A1|1A2|A2'
  #
  class Encoder
    def initialize(definitions = DEFINITIONS)
      @text_encoder = TextEncoder.new(definitions)
      @file_encoder = FileEncoder.new(definitions)
    end

    def encode_text(text)
      @text_encoder.encoded(Input::Text.new(text))
    end

    def encode_file(filepath)
      file = @file_encoder.encoded(Input::File.new(filepath))
      file.path
    end
  end
end
