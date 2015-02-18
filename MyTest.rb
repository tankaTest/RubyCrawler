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
arrayLink = response.body.scan(regex)
#puts linksArray



for element in arrayLink do
	begin
	puts element
	uri = URI.parse(element)
	puts 'URI host: ' + uri.host

	rescue 
    # Error found
    #puts "Error found during parsing  (URI::InvalidURIError)"
	ensure
	end
end
