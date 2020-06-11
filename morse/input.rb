require 'forwardable'

module Morse
  module Input
    # :nodoc:
    class File < Struct.new(:filepath)
      def text_content
        Input::Text.new(file_content)
      end

      private

      def file_content
        @file_content ||= ::File.read(filepath)
      end
    end

    # :nodoc:
    class Text < Struct.new(:text)
      def lines
        (text || '').split("\n").map { |line| Line.new(line) }
      end
    end

    #:nodoc:
    class Line < Struct.new(:line)
      def words
        (line || '').split(' ').map { |word| Word.new(word) }
      end
    end

    #:nodoc:
    class Word < Struct.new(:word)
      extend Forwardable
      def_delegators :word, :chars
    end
  end
end
