
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
# require 'fileutils'
require 'json'

CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.json")
MAXRESULTS = 4

SCHEDULER.every '10s', :first_in => 0 do
  # check if our API-Key is present
  if ENV["GCAL_CLIENT_ID"] == nil || ENV["GCAL_CLIENT_SECRET"] == nil
    send_event('calendar', { errormsg: "No Client ID / Client Secret specified!" })
  else
    authorize

    client = Google::APIClient.new(:application_name => "Dashboard Calender Widget")
    client.authorization = authorize
    calendar_api = client.discovered_api('calendar', 'v3')

    calendars = client.execute!(
      :api_method => calendar_api.calendar_list.list,
      :parameters => {
        :calendarId => 'primary',
        :maxResults => 10,
        :singleEvents => true,
        :orderBy => 'startTime',
        :timeMin => Time.now.iso8601 })
    # puts results

    upcomingEvents = Hash.new
    counter = 0

    calendars.data.items.each do |calendar|
      # start = event.start.date || event.start.date_time
      calenderID = "#{calendar.id}"
      nextEvents = client.execute!(
        :api_method => calendar_api.events.list,
        :parameters => {
          :calendarId => calenderID,
          :maxResults => MAXRESULTS,
          :singleEvents => true,
          :orderBy => 'startTime',
          :timeMin => Time.now.iso8601 })
      nextEvents.data.items.each do |event|
        # ent:"#{event.creator.email || event.creator.displayName} - #{event.summary} (#{event.start.date || event.start.date_time}) - (#{event.end.date || event.end.date_time})" }
        upcomingEvents["#{counter}"] = { hostCalendar: calendar.id, event: event, nextEvent:"@ #{calendar.id} - #{event.creator.email || event.creator.displayName} - #{event.summary}" }
        counter += 1
      end
    end
    send_event('calendar', { calendars: calendars.body, events: upcomingEvents.values, maxResults: MAXRESULTS })
  end
end

def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
  storage = Google::APIClient::Storage.new(file_store)
  auth = storage.authorize

  if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
    app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
    flow = Google::APIClient::InstalledAppFlow.new({
      :client_id => ENV["GCAL_CLIENT_ID"],
      :client_secret => ENV["GCAL_CLIENT_SECRET"],
      :scope => "https://www.googleapis.com/auth/calendar.readonly"})
    auth = flow.authorize(storage)
    puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
  end
  auth
end
