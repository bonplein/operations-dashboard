require 'net/http'
require 'json'

uri = URI("http://transport.opendata.ch/v1/connections?from=zurich&to=konstanz")

SCHEDULER.every '5s' do
  result = Hash.new
  result[1] = getData(uri)

  send_event('sbb-integration', { items: result[1].values })
end


def getData(uri)
  Net::HTTP.get(uri)
  res = Net::HTTP.get_response(uri)
  sbb = JSON.parse(res.body)

  connection = Hash.new

  id = 0

  sbb['connections'].each {|con|
    products = Array.new
    con['products'].each{|prod|
      products.push("#{prod}")
    }

    puts "#{products}"

    secNo = 0
    con['sections'].each{|sec|
      if secNo == 0
        puts "#{sec.length}"
      else
        puts "#{sec.length}"
      end
      secNo += 1
    }

    connection[id] = { from: "#{con['from']['location']['name']}", to:"#{con['to']['location']['name']}", travelTime: "#{con['duration']}", changes: "#{products.length - 1}", products: products }
    id += 1
  }

  puts "#{connection}"
  return connection

end
