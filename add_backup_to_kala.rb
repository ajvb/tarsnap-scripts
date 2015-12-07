# Based off the example ruby script in Kala's main repo.

require 'net/http'
require 'time'
require 'json'

API_URL = URI('http://127.0.0.1:8000/api/v1/job/')
def post_to_kala(data)
    req = Net::HTTP::Post.new(API_URL)
    req.body = data.to_json
    res = Net::HTTP.start(API_URL.host, API_URL.port) do |http|
      http.request(req)
    end

    if res.body
      JSON.parse(res.body)
    else
      res
    end
end

data = {
  name: 'tarsnap_backup',
  command: "ruby #{Dir.pwd}/backup_laptop.rb",
  epsilon: 'PT5S',
  schedule: "R/#{(Time.now + 120).iso8601}/P1DT"
}

puts "Sending request to #{API_URL}"
puts "Payload is: #{data}\n\n"

job_id = post_to_kala(data)['id']
puts "Job was created with an id of #{job_id}"
