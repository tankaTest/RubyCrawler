require 'net/http'
require "net/https"
require "uri"
require 'set'
require 'nokogiri'

$recursionArray = Set.new []
$totalAverages = Array.new []


def print_links_to_xml
builder = Nokogiri::XML::Builder.new do |xml|
	xml.root {
	for element in $recursionArray
	xml.link('url' => element) {

	
		uri = URI.parse(element)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri)
	
		begin
		response = http.request(request)
		price_occurences response,xml
		words_counter response,xml
		rescue
		ensure
		end
	}
	end
	xml.totalAverage ($totalAverages.reduce(:+) / $totalAverages.size).round(2)
	}
	end
	puts builder.to_xml
end


def price_occurences(response,xml)
respBody = response.body.force_encoding("UTF-8")

price_with_currency = respBody.scan(/\u20AC[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?/)
#price_with_currency = respBody.scan(/[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?\u20AC/)
#p price_with_currency

price = price_with_currency.map{ |i| i.gsub(/[^\d\.]/, '').to_f }
#p price

average = (price.reduce(:+) / price.size).round(2)
#puts average

$totalAverages.push(average)
xml.average_price average
end


def words_counter(response,xml)
response = response.body
page = Nokogiri::HTML(response)
page.css('script, link, title').each { |node| node.remove }

loan = page.css('body').inner_text.scan(/\b(?i)loan\b/)
invest = page.css('body').inner_text.scan(/\b(?i)invest\b/)

xml.loan_count loan.length
xml.invest_count invest.length
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
		#price_occurences(response)
		#words_counter(response)
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
print_links_to_xml
