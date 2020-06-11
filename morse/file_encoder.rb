module Morse
  ##
  # Responsible to encode a given file's content, writing
  # the encoded content to a separate '.encoded' file.
  class FileEncoder
    def initialize(filepath, definitions = DEFINTIONS)
      @file_path = filepath
      @encoded_file_path = "#{@file_path}.encoded"
      @definitions = definitions
    end

    def encoded
      File.absolute_path(encoded_file)
    end

    private

    def encoded_file
      @encoded_file ||= begin
        content = encoded_content

        File.open(@encoded_file_path, "w+").tap do |f|
          f.puts(content)
          f.close
        end
      end
    end

    def encoded_content
      text_encoder(file_content).encoded
    end

    def file_content
      File.read(@file_path)
    end

    def text_encoder(text)
      TextEncoder.new(text, @definitions)
    end
  end
end
