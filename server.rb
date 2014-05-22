require 'sinatra'
require 'csv'
require_relative 'helpers'
require 'pry'

get '/' do
  @articles = make_data().reverse
  erb :index
end
