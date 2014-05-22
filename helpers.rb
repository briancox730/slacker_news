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
  if Net::HTTP.get_response(URI.parse(url)).code != "200"
    return true
  end
  false
end

def check_desc(desc)
  if desc.length < 20
    return true
  end
  false
end

def save_post(array)
  array << Time.now
  File.open('data/articles.csv', 'a') do |file|
    file.puts(array.join(","))
  end
end
