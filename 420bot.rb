require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'

Giphy.configure do |config|
  config.rating = 'R'
end

class Four20Bot < SlackRubyBot::Bot
  command '420' do |client, data, match|
    # c.say(text: 'https://giphy.com/gifs/mrw-state-president-Jnx5ztK49mHJe', channel: d.channel)
    client.say(channel: data.channel, text: '420, blaze it.', gif: 'weed')
  end
end

Four20Bot.run