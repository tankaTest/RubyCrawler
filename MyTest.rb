require "net/https"
require "uri"
require 'set'

$recursionArray = Set.new []

def visit_url(new_uri, i)
	
	if i>10 then 
		return
	end
	
	if $recursionArray.include?(new_uri) == false then
		$recursionArray.add(new_uri)
	else 
		return
	end
	
	puts " "*i+new_uri
	
	home_uri="https://www.bondora.com/"
	uri = URI.parse(new_uri)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	
		begin
		response = http.request(request)
		rescue
		ensure
		end

	regex = /href="\/([^"]+)"/
	arrayLink = response.body.scan(regex)
	arrayLinkUniq = arrayLink.uniq
	
	for element in arrayLinkUniq do
	new_uri = "#{home_uri}#{element[0]}"		
	visit_url new_uri, i+1
	end
end

home_uri="https://www.bondora.com/"
visit_url home_uri, 0

#puts "Full:"
#$recursionArray.each{ |i| puts i } 
#puts $recursionArray.length
