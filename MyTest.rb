require 'net/http'
require "net/https"
require "uri"
require 'set'
require 'nokogiri'

$recursionArray = Set.new []

def price_occurences(response)
respBody = response.body.force_encoding("UTF-8")

price_with_currency = respBody.scan(/\u20AC[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?/)
p price_with_currency

price = price_with_currency.map{ |i| i.gsub(/[^\d\.]/, '').to_f }
p price

puts "Average:"
puts (price.reduce(:+) / price.size).round(2)
end


def words_counter(response)
response = response.body
page = Nokogiri::HTML(response)
page.css('script, link, title').each { |node| node.remove }

loan = page.css('body').inner_text.scan(/\b(?i)loan\b/)
invest = page.css('body').inner_text.scan(/\b(?i)invest\b/)

puts "Loan case insensitive:"
#puts array3
puts loan.length

puts "Invest insensitive:"
#puts array3
puts invest.length
end


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
		price_occurences(response)
		words_counter(response)
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



