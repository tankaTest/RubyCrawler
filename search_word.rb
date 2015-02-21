require "net/http"
require "uri"
require 'open-uri'
require 'rubygems'
require "net/https"
require "uri"
require 'set'

	
	home_uri="https://www.bondora.com/en/loan"
	uri = URI.parse(home_uri)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	
response = response.body

#puts response
page = Nokogiri::HTML(response)
#puts page

page.css('script, link').each { |node| node.remove }
#puts page.css('body').inner_text
puts page.inner_text
#puts page.css('body').text.squeeze(" \n")

#puts page.text
