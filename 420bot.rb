require './config.rb'

scheduler = Rufus::Scheduler.new
# scheduler.cron '*/1 * * * *' do
scheduler.cron '20 16 * * 1-5' do
  client = Slack::Web::Client.new
  client.chat_postMessage(channel: '#dev', text: '420bot 420', as_user: true)
end

class Four20Bot < SlackRubyBot::Bot
  command '420' do |client, data, match|
    client.say(channel: data.channel, text: 'Blaze it.', gif: 'weed')
  end

  command 'reddit' do |client, data, match|
    client.say(channel: data.channel, text: 'Like dust in the wind...')
    # client.say(channel: data.channel, text: "#{reddit_trees}")
  end

  command 'beta' do |client,data,match|
    client.say(channel: data.channel, text: "He's dead Jim. https://tenor.com/view/startrek-bones-dead-hesdeadjim-gif-5919210")
  end

  def self.reddit_trees
    response = HTTParty.get('https://www.reddit.com/r/trees.json', headers: { "User-Agent" => 'script:420bot:v0.1 (by /u/cmandr1)'})

    return "Shits real broke yo, #{response.code} style." unless response.code == 200

    parsed_response = JSON.parse(response.body)['data']['children']

    return 'Shits broke yo.' if parsed_response.count < 1

    posts = parsed_response.map { |post| { title: post['data']['title'], url: post['data']['url'] } }

    return posts.first(3)

    # First way to do it, make a big string and just print that out. Don't like it, I think I want to do separate messages.
    # return_string = ''
    # posts.each_with_index do |p,i|
    #   break if i > 2
    #   return_string += "#{i+1}. #{p[:title]} (#{p[:url]}) "
    # end
    # return_string
  end
end

Four20Bot.run