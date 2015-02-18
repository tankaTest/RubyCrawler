require "net/https"
require "uri"

uri = URI.parse("https://www.bondora.com/")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)
#puts response.body
#puts response.status

regex=/href="([^"]+)"/
myarray = response.body.scan(regex)
puts myarray

