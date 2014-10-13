json.array!(@podcasts) do |podcast|
  json.extract! podcast, :id, :name
  json.url podcast_url(podcast, format: :json)
end
