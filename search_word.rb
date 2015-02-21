require 'nokogiri'
require "net/http"
require "uri"
require 'open-uri'
require 'rubygems'
require "net/https"
require "uri"
require 'set'

	
	home_uri="https://www.bondora.com/en/loan/"
	uri = URI.parse(home_uri)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	
response = response.body

page = Nokogiri::HTML(response)
page.css('script, link, title').each { |node| node.remove }


#array1 = page.css('body').inner_text.scan(/.{0,20}loan.{0,20}/)
#array2 = page.css('body').inner_text.scan(/.{0,20}Loan.{0,20}/)
array1 = page.css('body').inner_text.scan(/loan/)
array2 = page.css('body').inner_text.scan(/Loan/)
array3 = page.css('body').inner_text.scan(/(?i)loan/)
array4= page.css('body').inner_text.scan(/LOAN/)

puts "loan count:"
#puts array1
#array1.each{ |i| puts i } 
puts array1.length

puts "Loan count:"
#puts array2
#array2.each{ |i| puts i } 
puts array2.length

puts "Loan case insensitive:"
puts array3
#array2.each{ |i| puts i } 
puts array3.length

#puts array4.length




