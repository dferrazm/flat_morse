module Morse
  ##
  # Responsible to encode a given file's content, writing
  # the encoded content to a separate '.encoded' file.
  class FileEncoder
    def initialize(definitions)
      @text_encoder = TextEncoder.new(definitions)
    end

    def encoded(file)
      encoded_content = encoded_content(file.text_content)

      File.open("#{file.filepath}.encoded", 'w+').tap do |f|
        f.puts(encoded_content)
        f.close
      end
    end

    private

    def encoded_content(text_content)
      @text_encoder.encoded(text_content)
    end
  end
end
