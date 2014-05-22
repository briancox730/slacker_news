def make_data()
  articles = []
  CSV.foreach('data/articles.csv', headers: true, header_converters: :symbol) do |row|
    articles << row.to_hash
  end
  articles
end

