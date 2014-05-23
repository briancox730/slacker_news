require 'net/http'
require 'csv'
require 'time'
require 'uri'
require 'json'

def get_connection
  if ENV.has_key?("REDISCLOUD_URL")
    Redis.new(url: ENV["REDISCLOUD_URL"])
  else
    Redis.new
  end
end

def find_articles
  redis = get_connection
  serialized_articles = redis.lrange("slacker:articles", 0, -1)

  articles = []

  serialized_articles.each do |article|
    articles << JSON.parse(article, symbolize_names: true)
  end

  articles
end

def save_article(author, url, title, description)
  article = { author: author, url: url, title: title, description: description, created: Time.now }

  redis = get_connection
  redis.rpush("slacker:articles", article.to_json)
end

def make_data()
  articles = []
  CSV.foreach('data/articles.csv', headers: true, header_converters: :symbol) do |row|
    articles << row.to_hash
  end
  articles
end

def check_blanks(author, title, url, desc)
  if author == "" || title == "" || url == "" || desc == ""
    return true
  end
  false
end

def check_url(url)
  begin
    if Net::HTTP.get_response(URI.parse(url)).code != "200"
      return true
    end
  rescue
    return true
  end
  false
end

def check_dupurl(url, articles)
  articles.each do |line|
    if url == line[:url]
      return true
    end
  end
  false
end

def check_desc(desc)
  if desc.length < 20
    return true
  end
  false
end

def make_time(time)
  if time < 60
    return time.to_s + " minutes ago"
  elsif time >= 60 && time < 1440
    return (time/60).round.to_s + " hours ago"
  elsif time >= 1440 && time < 10080
    return (time/1440).round.to_s + " days ago"
  elsif time >= 10080 && time < 43200
    return (time/10080).round.to_s + " weeks ago"
  elsif time > 43200
    return (time/518400).round.to_s + " years ago"
  end
end

def strip_url(url)
  url = url.split(".")
  url[-2] + "." + url[-1]
end

def save_post(array)
  array << Time.now
  File.open('data/articles.csv', 'a') do |file|
    file.puts(array.join(","))
  end
end
