require 'dotenv'
Dotenv.load

require 'rufus-scheduler'
require 'slack-ruby-bot'
require 'yaml'

config = YAML.load_file('config.yaml')

CHANNEL = config['channel']

# Rufus uses Ruby time.
ENV['TZ'] = config['time_zone']
SCHEDULER = Rufus::Scheduler.new


Giphy.configure do |config|
  config.rating = 'R'
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

SlackRubyBot.configure do |config|
  config.allow_message_loops = true
end