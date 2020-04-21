require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'redcarpet'
require 'pry'

require_relative 'q_a_parsing'

get "/" do
  erb :input
end

post "/submit" do
  @parsed_md = parse_for_q_a(params[:markdown]).join
  erb :display_md
end
