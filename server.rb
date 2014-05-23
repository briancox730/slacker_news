require 'sinatra'
require 'csv'
require_relative 'helpers'
require 'pry'
require 'net/http'
require 'uri'
require 'time'
require 'redis'
require 'json'

get '/' do
  @articles = find_articles() #.sort_by { |rowhash| (Time.parse(Time.now.to_s) - Time.parse(rowhash[:created])).to_i }
  erb :index
end

get '/submit' do
  @author = ""
  @title = ""
  @url = ""
  @desc = ""
  @resubmit = false
  erb :'submit/submit'
end

post '/submit' do
  @articles = make_data()
  @author = params["author"]
  @title = params["title"]
  @url = params["url"]
  @desc = params["desc"]
  if check_blanks(@author, @title, @url, @desc) || check_url(@url) || check_desc(@desc) || check_dupurl(@url, @articles)
    @resubmit = true
    erb :'submit/submit'
  else
    save_article(@author, @url, @title, @desc)
    redirect '/'
  end
end
