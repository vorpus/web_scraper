#!/usr/bin/env ruby

require 'time'
require 'uri'
require 'openssl'
require 'base64'

AWS_ACCESS_KEY_ID = "access_key"
AWS_SECRET_KEY = "secret_key"
ENDPOINT = "webservices.amazon.com"
REQUEST_URI = "/onca/xml"

def secured_url(keyword, color)
  params = {
    "Service" => "AWSECommerceService",
    "Operation" => "ItemSearch",
    "AWSAccessKeyId" => AWS_ACCESS_KEY_ID
    "AssociateTag" => "vgfashion-20",
    "SearchIndex" => "All",
    "Keywords" => "#{keyword} #{color.gsub(/[()]/, '')}",
    "ResponseGroup" => "Images,ItemAttributes,Offers,VariationOffers,VariationSummary"
  }

  params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

  canonical_query_string = params.sort.collect do |key, value|
    [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
  end.join('&')

  string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"

  signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), AWS_SECRET_KEY, string_to_sign)).strip()

  request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"

  return request_url
end
