require 'net/http'
require 'json'
require 'uri'

def ghet u
  uri = URI.parse(u)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  body = JSON.parse(response.body)

end

def explode hash
  hash.each do |k,v|
    self.class.send(:define_method, k, proc{v})
  end
end
