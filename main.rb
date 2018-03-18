require './parser.rb'

parser = Parser.new(File.read('./main.c'))

tokens = parser.parse
tokens.debug
