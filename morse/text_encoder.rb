module Morse
  ##
  # Responsible to encode a given text string, i.e.,
  # a whole text which can contain several lines.
  class TextEncoder < BaseEncoder
    def initialize(definitions)
      @line_encoder = LineEncoder.new(definitions)
    end

    def encoded(text)
      @line_encoder.encoded_multiple(text.lines).join(LINE_SEPARATOR)
    end
  end
end
