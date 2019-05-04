require './config.rb'

SCHEDULER.cron '20 16 * * 1-5' do
  client = Slack::Web::Client.new
  client.chat_postMessage(channel: CHANNEL, text: "4:20, blaze it. #{Gif.fetch_gif('weed')}", as_user: true)
end

class Four20Bot < SlackRubyBot::Bot
  command 'What time is it?' do |client, data, match|
    client.say(channel: data.channel, text: "4:20, blaze it. #{Gif.fetch_gif('weed')}")
  end
end

begin
  Four20Bot.run
rescue Slack::RealTime::Client::ClientNotStartedError => e
  File.open("errors.log","a") { |f| f.puts(e.message) }
  retry
end