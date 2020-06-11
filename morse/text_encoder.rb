module Morse
  ##
  # Responsible to encode a given text string, i.e.,
  # a whole text which can contain several lines.
  class TextEncoder
    def initialize(definitions)
      @line_encoder = LineEncoder.new(definitions)
    end

    def encoded(text)
      encoded_lines(text.lines).join(LINE_SEPARATOR)
    end

    private

    def encoded_lines(lines)
      lines.map { |line| @line_encoder.encoded(line) }
    end
  end
end
