require 'net/http'
require 'json'

# password = File.read('apipassword.txt')

uri = URI("https://slack.com/api/users.list?token=" + File.read('apipassword.txt') + "&presence=1")

SCHEDULER.every '5s' do
  Net::HTTP.get(uri)
  res = Net::HTTP.get_response(uri)
  slack = JSON.parse(res.body)

  users = Hash.new

  slack['members'].each{ |mem|
    if "#{mem['is_restricted']}" == "false" && "#{mem['is_bot']}" != "true" && "#{mem['id']}" != "USLACKBOT"
      users["#{mem['id']}"] = { label: "#{mem['name']}", value: "#{mem['presence']}" }
    end
  }

  send_event('slack-integration', { items: users.values })
end
