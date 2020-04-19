require 'bundler/setup'
require 'sinatra'

require_relative 'q_a_parsing'

get "/" do
  parse_for_q_a(File.read('test.md'))
end