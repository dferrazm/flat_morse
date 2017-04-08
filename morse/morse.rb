require 'yaml'

class Morse
  DEFINITIONS = YAML.load_file('definitions.yml').freeze

  def encode(char)
    DEFINITIONS[char]
  end
end
