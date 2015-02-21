# encoding=utf-8 
require 'net/http'
require "net/https"
require "uri"

uri = URI.parse('https://www.bondora.com/en/fees/')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)
respBody = response.body.force_encoding("UTF-8")

test_price=respBody.scan(/\u20AC[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?/)
p test_price
test_price.each{ |i| puts i.gsub(/[^\d\.]/, '').to_f }
