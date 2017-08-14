require 'net/http'
require 'uri'
require 'nokogiri'

module TiaCrawler
  class Networking
    def self.post(url, headers, body, ssl = true)
      uri = URI.parse url
      https = Net::HTTP.new uri.host, uri.port
      https.use_ssl = ssl
      req = Net::HTTP::Post.new uri.path, headers
      req.set_form_data body unless body.nil?
      res = https.request req
      return res
    end
  end
end
