require './config.rb'

SCHEDULER.cron '20 16 * * 1-5' do
  client = Slack::Web::Client.new
  client.chat_postMessage(channel: CHANNEL, text: '420bot 420', as_user: true)
end

class Four20Bot < SlackRubyBot::Bot
  command '420' do |client, data, match|
    client.say(channel: data.channel, text: 'Blaze it.', gif: 'weed')
  end
end

Four20Bot.run