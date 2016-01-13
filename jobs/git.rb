require 'net/http'
require 'json'

SCHEDULER.every '90s', :first_in => 0 do
  # check if our API-Key is present
  if ENV["GIT_AUTH_TOKEN"] == nil
    send_event('git', { errormsg: "No API-Key specified!" })
  else

    uri = URI("https://api.github.com/user/repos?access_token=" + ENV["GIT_AUTH_TOKEN"])
    Net::HTTP.get(uri)
    res = Net::HTTP.get_response(uri)
    repositories = JSON.parse(res.body)

    if repositories.is_a? Array
      sendData(repositories)
    else
      # error from GitHub
      puts "#{repositories['message']}\nSee: #{repositories['documentation_url']} for more Infos"
      send_event('git', { errormsg: "#{repositories['message']}", errormsg2:"See: #{repositories['documentation_url']} for more Infos"})
    end
  end
end

# parse the data received from GitHub
def sendData(repositories)

  repos = Hash.new

  sendToWidget = Hash.new

  repositories.each{ |repo|
    repos["#{repo['id']}"] = { "name"=> "#{repo['name']}", "repoURI" => "https://api.github.com/repos/#{repo['full_name']}/milestones?access_token=" + ENV['GIT_AUTH_TOKEN'], "repoId" => "#{repo['id']}"}
  }

  openIssues = 0
  closedIssues = 0

  repos.values.each{ |repo|
    openIssuesRepo = 0
    closedIssuesRepo = 0
    milestones = Hash.new
    noMilestones = true
    repoURI = URI("#{repo['repoURI']}")
    Net::HTTP.get(repoURI)
    repoRes = Net::HTTP.get_response(repoURI)
    repository = JSON.parse(repoRes.body)

    repository.each{ |milestone|
      openIssues += Integer("#{milestone['open_issues']}")
      closedIssues += Integer("#{milestone['closed_issues']}")
      openIssuesRepo += Integer("#{milestone['open_issues']}")
      closedIssuesRepo += Integer("#{milestone['closed_issues']}")
      milestones["#{milestone['id']}"] = { title: "#{milestone['title']}", open: "#{milestone['open_issues']}", closed:"#{milestone['closed_issues']}", due: "#{milestone['due_on']}"}
      noMilestones = false
    }
    if !noMilestones
      sendToWidget["#{repo['repoId']}"] = { title: "#{repo['name']}", milestones: milestones.values, openIssues: openIssuesRepo, closedIssues: closedIssuesRepo }
    end
  }

  puts sendToWidget
  overall = ""
  if openIssues == 0 && closedIssues == 0
    overall = "Couldn't find any milestones in your Repositories :("
  else
    overall = "Overall progress: #{closedIssues} / " + String(Integer("#{openIssues}") + Integer("#{closedIssues}")) + " Issues done!"
  end

  send_event('git', { overall: overall, repos: sendToWidget.values})
end
