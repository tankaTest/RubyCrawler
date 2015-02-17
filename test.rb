require 'net/http'
require "net/https"
require "uri"

uri = URI.parse('https://www.bondora.com')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)
#puts response.body
arrayContent = URI.extract(response.body, ['http', 'https'])

for element in arrayContent do
	begin
	puts element
	uri = URI.parse(element)
	rescue 
    # Error found
    puts "Error found during parsing  (URI::InvalidURIError)"
	ensure
	end
end
