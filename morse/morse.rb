require 'yaml'

module Morse
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

  class ObfuscatedDefinitions
    def initialize(definitions)
      @definitions = definitions
    end

    def code(char)
      obfuscated(@definitions.code(char))
    end

    private

    def obfuscated(code)
      obfuscated_sequences(code).join
    end

    def obfuscated_sequences(code)
      char_sequences(code).map do |sequence, type|
        OBFUSCATOR[type].call(sequence)
      end
    end

    # This regex will scan the morse code to find the repeated characters.
    # It returns an array of 2-tuples, the first element being the sequence
    # and second element being the repeated character. Ex:
    # Input: '...--..-'
    # Output: [['...','.'], ['--','-'], ['..','.'],['-','-']]
    def char_sequences(code)
      code.scan(/((.)\2*)/)
    end

    ALPHABET = ('A'..'Z').to_a.freeze
    DOT = '.'.freeze
    DASH = '-'.freeze

    OBFUSCATOR = {
      DOT => ->(dots) { dots.length },
      DASH => ->(dashes) { ALPHABET[dashes.length - 1] }
    }
  end

  DEFINITIONS = Definitions.new(YAML.load_file('definitions.yml')).freeze
  OBFUSCATED_DEFINITIONS = ObfuscatedDefinitions.new(DEFINITIONS).freeze
  WORD_SEPARATOR = '/'.freeze
  CHAR_SEPARATOR = '|'.freeze

  class Encoder
    def initialize(definitions = DEFINITIONS)
      @definitions = definitions
    end

    def encode_text(text)
      text_encoder(text).encoded
    end

    def encode_file(file)
      file_encoder(file).encoded
    end

    private

    def text_encoder(text)
      TextEncoder.new(text, @definitions)
    end

    def file_encoder(filepath)
      FileEncoder.new(filepath, @definitions)
    end
  end

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
      @encoded_content ||= file_content.map do |line|
        line_encoder(line).encoded
      end
    end

    def file_content
      @file_content ||= File.readlines(@file_path)
    end

    def line_encoder(line)
      TextEncoder.new(line, @definitions)
    end
  end

  class TextEncoder
    def initialize(text, definitions = DEFINTIONS)
      @text = text || ''
      @definitions = definitions
    end

    def encoded
      encoded_words.join(WORD_SEPARATOR)
    end

    private

    def encoded_words
      words.map { |word| word_encoder(word).encoded }
    end

    def words
      @text.split(' ')
    end

    def word_encoder(word)
      WordEncoder.new(word, @definitions)
    end
  end

  class WordEncoder
    def initialize(word, definitions = DEFINITIONS)
      @word = word
      @definitions = definitions
    end

    def encoded
      encoded_chars.join(CHAR_SEPARATOR)
    end

    private

    def encoded_chars
      chars.map { |char| @definitions.code(char) }
    end

    def chars
      @word.chars
    end
  end

  class InvalidChar < StandardError
    def initialize(char)
      super("Character '#{char}' is unmapped")
    end
  end
end
