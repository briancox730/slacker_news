require 'sinatra'
require 'csv'
require_relative 'helpers'
require 'pry'

get '/' do
  @articles = make_data()
  erb :index
end
