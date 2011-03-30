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
  @commits = ghet ("http://github.com/api/v2/json/commits/list/#{params[:user]}/#{params[:repo]}/#{params[:tag]}")

  if @commits.include?"error"
    @title = "Not found..."
    erb :nf
  else
    @tmitts = @commits['commits'].map do |x|
      [x['committer']['login'], x['id']]
    end.group_by {|x|x[0]}.each do |k,v|
      v.flatten!.select! {|x| x != k}
    end
  end
end
