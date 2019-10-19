require 'dotenv'
Dotenv.load

require 'rufus-scheduler'
require 'slack-ruby-bot'
require 'yaml'
require 'httparty'
require './gif.rb'
require 'byebug'

config = YAML.load_file('config.yaml')

CHANNEL = config['channel']

# Rufus uses Ruby time.
ENV['TZ'] = config['time_zone']
SCHEDULER = Rufus::Scheduler.new

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

# SlackRubyBot.configure do |config|
#   config.allow_message_loops = true
# end

SlackRubyBot::Client.logger.level = Logger::DEBUG