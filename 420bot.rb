require './config.rb'

SCHEDULER.cron '20 16 * * 1-5' do
  client = Slack::Web::Client.new
  client.chat_postMessage(channel: CHANNEL, text: "4:20, blaze it. #{Gif.fetch_gif('weed')}", as_user: true)
end

class Four20Bot < SlackRubyBot::Bot
  command 'What time is it?' do |client, data, match|
    client.say(channel: data.channel, text: "4:20, blaze it. #{Gif.fetch_gif('weed')}")
  end

  command 'what do we say' do |client, data, match|
    client.say(channel: data.channel, text: "Not today. #{Gif.fetch_gif('not-today')}")
  end

  command 'ban' do |client, data, match|
    File.open('blacklist.txt','a') { |f| f.puts("#{match[:expression]}") }
    client.say(channel: data.channel, text: 'Done.')
  end

  scan /\b(facts*)\b/ do |client, data, match|
    text = HTTParty.get('https://uselessfacts.jsph.pl/random.json?language=en')["text"]
    client.say(channel: data.channel, text: text)
  end
end

begin
  Four20Bot.run
rescue StandardError => e
  File.open("errors.log","a") do |f| 
    f.puts("Reboot-420bot")
    f.puts(e.message)
  end
  retry
end
