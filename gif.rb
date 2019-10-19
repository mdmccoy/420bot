module Gif
  require 'GiphyClient'

  class BlackListError < StandardError; end

  def self.fetch(subject)
    api_instance = GiphyClient::DefaultApi.new

    args = {
        tag: subject,
        rating: "r",
        fmt: "json"
    }

    begin
      # make two calls here because the random endpoint doesn't return the downsized gif
      random_id = api_instance.gifs_random_get(ENV['GIPHY_API_KEY'], args).to_hash.dig(:data,:id)

      raise Gif::BlackListError if Gif.blacklisted?(random_id)

      result = api_instance.gifs_gif_id_get(ENV['GIPHY_API_KEY'], random_id)
      result.to_hash.dig(:data,:images,:downsized,:url)
    rescue GiphyClient::ApiError => e
      puts "Exception when calling DefaultApi->gifs_random_get: #{e}"
    rescue Gif::BlackListError => e
      puts "That gif id #{random_id} is banned."
      retry
    end
  end

  def self.blacklisted?(gif_id)
    return false unless File.file?('blacklist.txt')

    File.readlines('blacklist.txt').any? { |line| line.strip == gif_id }
  end
end
