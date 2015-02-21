require 'nokogiri'
require "net/http"
require "net/https"
	
	home_uri="https://www.bondora.com/en/loan/loan-application"
	uri = URI.parse(home_uri)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	
response = response.body

page = Nokogiri::HTML(response)
page.css('script, link, title').each { |node| node.remove }

array3 = page.css('body').inner_text.scan(/(?i)loan/)

puts "Loan case insensitive:"
#puts array3
puts array3.length





