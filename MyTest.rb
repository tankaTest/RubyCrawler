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

regex=/(href="\/[^"]+")/
arrayLink = response.body.scan(regex)
arrayLinkUniq = arrayLink.uniq
#puts linksArray



for element in arrayLinkUniq do
	begin
	puts element
	
	rescue 
    # Error found
    #puts "Error found during parsing  (URI::InvalidURIError)"
	ensure
	end
end

