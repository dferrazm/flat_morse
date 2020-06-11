A Morse encoder implemented with good OOP design (imho).

The program encodes a file or a string content in a Morse format.

## Encoding

Assuming that Morse code mapping for the following chars:
- "A" => ".-"
- "B" => "-..."
- "1" => ".----"
- "2" => "..---"
- "3" => "..---"

To encode the string "Ab 123", we get the following result:

```rb
encoder = Morse::Encoder.new
encoder.encode_text("Ab 123") # => ".-|-.../.----|..---|..---"
```

From this example, we can note 3 rules used by the encoder:
- The encoder is case insensitive.
- Each encoded character is separated by a `|`.
- Each encoded word is separated by a `/`.

Currently, the default Morse code mapping is used: [definitions.yml](definitions.yml).
In order to use a different set of mappings, you can provide them to the `Encoder` constructor.

```rb
my_mappings = { 'A' => '.', 'B' => '..', 'C' => '...'}

encoder = Morse::Encoder.new(my_mappings)
encoder.encode_text("abc") # => ".|..|..."
```

When encoding a text with line-breaks, they will be kept intact. Ex:

```rb
encoder.encode_text("Ab\n123")
# => Results in
# .-|-...
# .----|..---|..---
```

It's possible to encode a file's content too. For this case you need
to pass the file path and you will get back the encoded `File` object.

```rb
encoder.encode_file(filepath) # => encoded `File` object.
```

## Obfuscated Encoding

The encoder has a built-in obfuscated mode. It basically obfuscates the resultant
Morse code based on a set of rules. Check `DefinitionsObfuscated` doc for more info on
the rules. Example:

```rb
encoder = Morse::EncoderObfuscated.new
encoder.encode_text("ab 123") # => "1A|A3/1D|2C|3B"
encoder.encode_file(filepath) # => encoded `File` object
```

## Decoding

TODO

## Commands

It's possible to use the program through a set of command lines. Run `rake -T` to
see the available commands and how to use them.

## Testing

Run `rake morse:test`
