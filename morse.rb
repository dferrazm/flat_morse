require 'yaml'

require_relative 'morse/definitions'
require_relative 'morse/definitions_obfuscated'
require_relative 'morse/input'
require_relative 'morse/encoder'
require_relative 'morse/base_encoder'
require_relative 'morse/file_encoder'
require_relative 'morse/text_encoder'
require_relative 'morse/line_encoder'
require_relative 'morse/word_encoder'
require_relative 'morse/char_encoder'
require_relative 'morse/invalid_char'

module Morse
  DEFINITIONS = Definitions.new(YAML.load_file('definitions.yml')).freeze
  OBFUSCATED_DEFINITIONS = DefinitionsObfuscated.new(DEFINITIONS).freeze
  WORD_SEPARATOR = '/'.freeze
  CHAR_SEPARATOR = '|'.freeze
  LINE_SEPARATOR = "\n".freeze
end
