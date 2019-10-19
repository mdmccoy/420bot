require './config.rb'

SCHEDULER.cron '20 16 * * 1-5' do
  client = Slack::Web::Client.new
  client.chat_postMessage(channel: CHANNEL, text: "4:20, blaze it. #{Gif.fetch('weed')}", as_user: true)
end

class Four20Bot < SlackRubyBot::Bot
  command 'What time is it?' do |client, data, match|
    client.say(channel: data.channel, text: "4:20, blaze it. #{Gif.fetch('weed')}")
  end

  command 'what do we say' do |client, data, match|
    client.say(channel: data.channel, text: "Not today. #{Gif.fetch('not-today')}")
  end

  command 'ban' do |client, data, match|
    File.open('blacklist.txt','a') { |f| f.puts("#{match[:expression]}") }
    client.say(channel: data.channel, text: 'Done.')
  end

  command 'update' do |client, data, match|
    # name = HTTParty.get("https://slack.com/api/users.info?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")['user']['real_name']
    name = client.web_client.users_info(user: data.user)['user']['real_name']
    standup = YAML.load(File.open('standup.yaml','a+')) || {}
    standup[name] = match[:expression]
    File.open('standup.yaml','w') { |f| f.write(standup.to_yaml) }
    client.say(channel: data.channel, text: 'Done.')
  end

  operator '!' do |client, data, match|
    case match[:expression]
    when 'standup'
      # Build the standup update, somehow. Loop through the file?
      reply = YAML.load(File.open('standup.yaml', 'r')).map do |k,v|
        {
          type: "section",
          text: {
            type: 'mrkdwn',
            text: "*#{k}* - #{v}"
          }
        }
      end

      client.web_client.chat_postMessage(
        channel: data.channel,
        blocks: reply,
        as_user: true
      )
    else
      client.say(channel: data.channel, text: "RIP #{Gif.fetch('fail')}")
    end
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
