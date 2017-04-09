require_relative 'morse'

task default: %w[morse:test]

namespace :morse do
  desc 'Run all the tests'
  task :test do
    ruby '-Ilib:test ./*_test.rb'
  end

  desc 'Encode and obfuscate a file\'s content passed through a `FILE` env variable'
  task :encode_file do
    result = morse.encode_file(ENV['FILE'])
    puts "Encoded file at #{result}"
  end

  desc 'Encode and obfuscate a text passed through a `TEXT` env variable'
  task :encode_text do
    puts morse.encode_text(ENV['TEXT'])
  end
end

def morse
  Morse::Encoder.new(Morse::OBFUSCATED_DEFINITIONS)
end
