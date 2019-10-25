module GoogleSheet
  require "google/apis/sheets_v4"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "fileutils"

  def self.get
    scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    authorization = Google::Auth.get_application_default(scope)

    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = authorization

    spreadsheet_id = ENV['SHEET_ID']
    range = "Main Priorities!A3:I"
    response = service.get_spreadsheet_values(spreadsheet_id, range)

    response.values.empty? ? "No data found." : response.values
  end

  def self.format_response(values)
    values.map do |row|
      row
    end
  end
end
