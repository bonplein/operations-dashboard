require 'net/http'
require 'json'

uri = URI("https://slack.com/api/users.list?token=" + ENV["SLACKAPIKEY"] + "&presence=1")

SCHEDULER.every '5s' do
  Net::HTTP.get(uri)
  res = Net::HTTP.get_response(uri)
  slack = JSON.parse(res.body)

  users = Hash.new

  slack['members'].each{ |mem|
    if "#{mem['is_restricted']}" == "false" && "#{mem['is_bot']}" != "true" && "#{mem['id']}" != "USLACKBOT"
      if "#{mem['presence']}" == "active"
        users["#{mem['id']}"] = { label: "#{mem['name']}", active: "●" }
      else
        users["#{mem['id']}"] = { label: "#{mem['name']}", inactive: "●" }
      end
    end
  }

  send_event('slack-integration', { items: users.values })
end
