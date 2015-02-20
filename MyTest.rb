require "net/https"
require "uri"
require 'set'

$i = 0
$recursionArray = Set.new []
p $recursionArray

def visit_url(new_uri)
puts " "*$i+new_uri
	$i += 1
	home_uri="https://www.bondora.com/"
	uri = URI.parse(new_uri)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)

	regex = /href="\/([^"]+)"/
	#arrayLink = []
	#harrayLinkUniq = []
	arrayLink = response.body.scan(regex)
	arrayLinkUniq = arrayLink.uniq
	
	for element in arrayLinkUniq do
		begin
		new_uri = "#{home_uri}#{element[0]}"		
			#Create unique array of links during recursion
			if $recursionArray.include?(new_uri) == false then
			$recursionArray.add(new_uri)
			#puts "Then  #{$i}  #{new_uri}"
				#recursion depth limit to exit from cycle
				if $i<4 then 
				visit_url (new_uri)
				end
			$recursionArray.add(new_uri)
			#puts " "*$i+new_uri
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

puts "Full:"
$recursionArray.each{ |i| puts i } 
puts $recursionArray.length
