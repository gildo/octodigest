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

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def tagger
  tags    = ghet ("http://github.com/api/v2/json/repos/show/#{params[:user]}/#{params[:repo]}/tags")
  commits = ghet ("http://github.com/api/v2/json/commits/list/#{params[:user]}/#{params[:repo]}/master")
  tag = params[:tag]
  explode tags
  explode commits
  page = "1"
  commits.each do |c|
    while !c.include?(tags[tag.to_s])
      commits.merge(ghet("http://github.com/api/v2/json/commits/list/#{params[:user]}/#{params[:repo]}/master?page#{page.next!}"))
    end
  end
  #start = commits.keys.find_index(tags.values[tags.keys.find_index(params[:tag]) - 1]) + 1
  #stop = commits.keys.find_index(tags[params[:tag]])
  #tmitts = commits.values[start, stop - start]
  #tmitts
end
