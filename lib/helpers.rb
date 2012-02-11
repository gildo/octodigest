require 'net/http'
require 'net/https'
require 'json'
require 'uri'

def ghet u
  uri = URI.parse(u)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  body = http.get(uri.path).body

  JSON.parse(body)
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
  tags    = ghet ("https://github.com/api/v2/json/repos/show/#{params[:user]}/#{params[:repo]}/tags")
  @tcommits = ghet ("https://github.com/api/v2/json/commits/list/#{params[:user]}/#{params[:repo]}/#{params[:tag]}")

  if @tcommits.include?"error"
    @title = "Not found..."
    erb :nf
  else
    @tmitts = @tcommits['commits'].map do |x|
      [x['committer']['login'], x['id']]
    end.group_by {|x|x[0]}.each do |k,v|
      v.flatten!.select! {|x| x != k}
    end
  end
end
