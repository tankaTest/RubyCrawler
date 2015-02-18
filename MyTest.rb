require "net/https"
require "uri"
require 'pathname'

home_uri="https://www.bondora.com/"
uri = URI.parse(home_uri)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)

regex=/href="\/([^"]+)"/
arrayLink = response.body.scan(regex)
arrayLinkUniq = arrayLink.uniq



for element in arrayLinkUniq do
	begin
	new_uri="#{uri}#{element[0]}"
	puts "#{uri}#{element[0]}"
	rescue 
    # Error found
    #puts "Error found during parsing  (URI::InvalidURIError)"
	ensure
	end
end
