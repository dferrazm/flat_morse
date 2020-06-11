module Morse
  ##
  # Responsible to encode a given text string, i.e.,
  # a whole text which can contain several lines.
  class TextEncoder
    def initialize(text, definitions = DEFINTIONS)
      @text = text
      @definitions = definitions
    end

    def encoded
      encoded_lines.join("\n")
    end

    private

    def encoded_lines
      lines.map { |line| line_encoder(line).encoded }
    end

    def lines
      @text.split("\n")
    end

    def line_encoder(line)
      LineEncoder.new(line, @definitions)
    end
  end
end
