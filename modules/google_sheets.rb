module GoogleSheet
  require 'google/apis/sheets_v4'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  require 'fileutils'

  def self.get
    scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    authorization = Google::Auth.get_application_default(scope)

    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = authorization

    spreadsheet_id = ENV['SHEET_ID']
    range = 'Main Priorities!A3:I'
    response = service.get_spreadsheet_values(spreadsheet_id, range)

    response.values.empty? ? 'No data found.' : response.values
  end

  def self.percentage_emoji(string)
    case string.to_f
    when 0.0
      ':not100:'
    when 100.0
      ':100:'
    else
      string
    end
  end

  def self.jira_link(ticket)
    "#{ENV['JIRA_URL']}#{ticket}"
  end

  def self.block_response
    self.get.map do |row|
      [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*#{row[0]}*\n#{self.jira_link(row[1])}"
          }
        },
        {
          type: 'context',
          elements: [
            {
              type: 'mrkdwn',
              text: "*Asignee:* #{row[5]}"
            },
            {
              type: 'mrkdwn',
              text: "*Points:* #{row.last}"
            },
            {
              type: 'mrkdwn',
              text: "*Status:* #{row[3]}"
            },
            {
              type: 'mrkdwn',
              text: "*Finish? * #{self.percentage_emoji(row[7])}"
            }
          ]
        },
        {
          type: 'context',
          elements: [
            {
              type: 'mrkdwn',
              text: "#{row[6]}"
            }
          ]
        },
        {
          type: 'divider'
        }
      ]
    end.flatten
  end
end
