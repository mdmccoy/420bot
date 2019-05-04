module Gif
  require 'GiphyClient'
  # require 'byebug'

  def self.fetch_gif(subject)
    api_instance = GiphyClient::DefaultApi.new

    args = {
        tag: subject,
        rating: "r",
        fmt: "json"
    }

    begin
      random_id = api_instance.gifs_random_get(ENV['GIPHY_API_KEY'], args).to_hash[:data][:id]
      result = api_instance.gifs_gif_id_get(ENV['GIPHY_API_KEY'], random_id)
      result.to_hash[:data][:images][:downsized][:url]
    rescue GiphyClient::ApiError => e
      puts "Exception when calling DefaultApi->gifs_random_get: #{e}"
    end
  end
end
