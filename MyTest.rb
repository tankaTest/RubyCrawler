require "net/https"
require "uri"
require 'set'

$i = 0
$recursionArray = Set.new []
p $recursionArray

def visit_url(new_uri)
	$i += 1
	home_uri="https://www.bondora.com/"
	uri = URI.parse(new_uri)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)

	regex = /href="\/([^"]+)"/
	
	#puts "Response body:"
	#puts response.body.scan(regex).uniq
	arrayLink = []
	harrayLinkUniq = []
	arrayLink = response.body.scan(regex)
	arrayLinkUniq = arrayLink.uniq
	
	puts "Full array: "
	p arrayLinkUniq
	

			
	for element in arrayLinkUniq do
		begin
		new_uri = "#{home_uri}#{element[0]}"
		#puts "URI takoj:"
		#puts uri
		#puts element
		#puts "New URI to visit:"
		#puts new_uri
		#visit_url (new_uri)
		
		#Create unique array of links during recursion
		#puts $recursionArray.include?(new_uri)
		if $recursionArray.include?(new_uri) == false then
		#$recursionArray.add(new_uri)
		#recursion depth limit to exit from cycle
			if $i<6 then 
			visit_url (new_uri)
			end
		$recursionArray.add(new_uri)
		end
		
		rescue 
		# Skip if Error found
		#puts "Error found during parsing  (URI::InvalidURIError)"
		ensure
		#continue operation
		end
	end
$i-=1
end


home_uri="https://www.bondora.com/"
visit_url (home_uri)

$recursionArray.each{ |i| puts i } 
puts $recursionArray.length
