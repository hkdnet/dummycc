require 'English'
$LOAD_PATH.unshift(File.expand_path('./lib', __dir__))

require 'dummycc'

parser = DummyCC::Parser.new(File.read('./main.c'))

tokens = parser.parse
tokens.debug
