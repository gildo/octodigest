require 'net/http'
require 'net/https'
require 'json'
require 'uri'

helpers do
  include Rack::Utils

  def fetch (uri)
    uri  = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    body = http.get(uri.path).body

    JSON.parse(body)
  end

  def explode (hash)
    hash.each {|key, value|
      define_singleton_method key do value end
    }
  end

  def tagger
    @tcommits = fetch "https://github.com/api/v2/json/commits/list/#{params[:user]}/#{params[:repo]}/#{params[:tag]}"

    if @tcommits.include? 'error'
      @title = 'Not found...'

      erb :nf
    else
      @tmitts = @tcommits['commits'].map {|x|
        [x['committer']['login'], x['id']]
      }.group_by { |x| x[0] }.each {|key, value|
        value.flatten.select { |x| x != key }
      }
    end
  end

  alias h escape_html
end
