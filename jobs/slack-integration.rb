require 'net/http'
require 'json'


SCHEDULER.every '90s', :first_in => 0 do
  # check if our API-Key is present
  if ENV["SLACKAPIKEY"] == nil
    send_event('slack-integration', { errormsg: "No API-Key specified!" })
  else

    uri = URI("https://slack.com/api/users.list?token=" + ENV["SLACKAPIKEY"] + "&presence=1")
    Net::HTTP.get(uri)
    res = Net::HTTP.get_response(uri)
    slack = JSON.parse(res.body)

    users = Hash.new

    # check if slack API sent us valid information
    if slack["ok"] != true
      send_event('slack-integration', { errormsg: "#{slack['error']}" })
    else

      # parse the information slack gave us
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
  end
end
