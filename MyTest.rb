require "net/https"
require "uri"
require 'pathname'
$i=0

def visit_url(home_uri)
	$i+=1
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
		#visit_url (new_uri)
		
if $i<3 then 
visit_url (new_uri)
end
		rescue 
		# Error found
		#puts "Error found during parsing  (URI::InvalidURIError)"
		ensure
		end
	end
$i-=1
end


home_uri="https://www.bondora.com/"
visit_url (home_uri)
