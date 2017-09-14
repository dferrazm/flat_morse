require 'yaml'

module Morse

  # Class that wraps the characters code definitions. It receives
  # a hash that maps each character that can be encoded to its target Morse code.
  # With that, each mapped character can be encoded calling the `code` method.
  # Example:
  #
  # defintions = Definitions.new({ 'a' => '.-', 'b' => '-...' })
  # defintions.code('a') # Returns '.-'
  # defintions.code('b') # Returns '-...'
  # defintions.code('c') # Returns InvalidChar error
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

  # Represents an obfuscated set of Morse code definitions. It decorates
  # a Definitions instance to return the resultant Morse code obfuscated, for a given character.
  # The obfuscation happens in the following manner:
  # - It replaces each sequence of dots with a number correnponding to the length of the sequence;
  # - It replaces each sequence of dashes with the letter in the alphabet (A...Z), grabbed by a given position,
  #   where the position corresponds the length of the sequence
  #
  # Example:
  #
  # defintions = Definitions.new({ 'b' => '-...', 'j' => '.---' })
  # obuscated = ObfuscatedDefinitions.new(definitions)
  # obfuscated.code('b') # Returns 'A3'
  # obfuscated.code('j') # Returns '1C'
  # obfuscated.code('c') # Returns InvalidChar error
  #
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
      DOT => ->(dots_sequence) { dots_sequence.length },
      DASH => ->(dashes_sequence) { ALPHABET[dashes_sequence.length - 1] }
    }
  end

  DEFINITIONS = Definitions.new(YAML.load_file('definitions.yml')).freeze
  OBFUSCATED_DEFINITIONS = ObfuscatedDefinitions.new(DEFINITIONS).freeze
  WORD_SEPARATOR = '/'.freeze
  CHAR_SEPARATOR = '|'.freeze

  # Represents a Morse encoder that, provided a set of definitions,
  # encodes plain text strings or files contents. Every encoded character
  # is separated with a pipe (|) and every word is separated with a forward slash (/).
  # It also does not care about letter case.
  # Example:
  #
  # encoder = Encoder.new(definitions)
  # encoder.encode_text('HELLO WORLD')  # Returns '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..'
  # encoder.encode_file('path/to/file') # Returns '....|.|.-..|.-..|---/.--|---|.-.|.-..|-..'
  #
  # encoder = Encoder.new(obfuscated_definitions)
  # encoder.encode_text('HELLO WORLD')  # Returns '4|1|1A2|1A2|C/1B|C|1A1|1A2|A2'
  # encoder.encode_file('path/to/file') # Returns '4|1|1A2|1A2|C/1B|C|1A1|1A2|A2'
  #
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
      TextEncoder.new(text || '', @definitions)
    end

    def file_encoder(filepath)
      FileEncoder.new(filepath, @definitions)
    end
  end

  # Encoder responsible to encoding a given file's content.
  # It encodes the text string with a TextEncoder.
  #
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

  # Encoder responsible to encoding a text string.
  # It encodes each line of the text with a LineEncoder.
  #
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

  # Encoder responsible to encoding a line string.
  # It encodes each word of the text with a WordEncoder.
  #
  class LineEncoder
    def initialize(line, definitions = DEFINTIONS)
      @line = line
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
      @line.split(' ')
    end

    def word_encoder(word)
      WordEncoder.new(word, @definitions)
    end
  end

  # Encoder responsible to encoding a word.
  # It encodes each character based on the received definitions.
  #
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
