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

def save_post(array)
  array << Time.now
  File.open('data/articles.csv', 'a') do |file|
    file.puts(array.join(","))
  end
end
