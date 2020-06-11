module Morse
  # :nodoc:
  class BaseEncoder
    def encoded(target); end

    def encoded_multiple(targets)
      targets.map { |target| encoded(target) }
    end
  end
end
