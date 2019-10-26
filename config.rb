require 'dotenv'
Dotenv.load

require 'rufus-scheduler'
require 'slack-ruby-bot'
require 'yaml'
require 'httparty'
require './modules/gif.rb'
require './modules/google_sheets.rb'

CHANNEL = ENV['CHANNEL']

# Rufus uses Ruby time.
ENV['TZ'] = ENV['TIMEZONE']
SCHEDULER = Rufus::Scheduler.new

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

# SlackRubyBot.configure do |config|
#   config.allow_message_loops = true
# end

SlackRubyBot::Client.logger.level = Logger::WARN