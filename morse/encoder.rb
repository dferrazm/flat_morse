module Morse
  ##
  # Represents a Morse encoder that, provided a set of definitions,
  # encodes plain text strings or files contents. Every encoded character
  # is separated with a '|' (pipe char) and every word is separated with a
  # forward '/' (forward slash). It is also case insensitive.
  # Example:
  #
  #   encoder = Encoder.new(definitions)
  #   encoder.encode_text('HELLO WORLD')  # => '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..'
  #   encoder.encode_file('path/to/file') # => '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..'
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
