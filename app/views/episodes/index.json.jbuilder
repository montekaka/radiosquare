json.array!(@episodes) do |episode|
  json.extract! episode, :id, :name, :podcast_id, :file_size, :lastmod, :url
  json.url episode_url(episode, format: :json)
end
