require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'
require 'rufus-scheduler'

Giphy.configure do |config|
  config.rating = 'R'
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

SlackRubyBot.configure do |config|
  config.allow_message_loops = true
end