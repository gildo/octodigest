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

  def populate (hash)
    hash.each {|name, value|
      next if instance_variable_defined? "@#{name}"

      instance_variable_set "@#{name}", value
    }
  end

  def tagger
    @tag = Struct.new(:commits, :commits_per_author).new

    @tag.commits = fetch "https://github.com/api/v2/json/commits/list/#{params[:user]}/#{params[:repository]}/#{params[:tag]}"

    if @tag.commits.include? 'error'
      return
    end

    @tag.commits_per_author = @tag.commits['commits'].map {|x|
      [x['committer']['login'], x['id']]
    }.group_by { |(name, _)| name }.each {|key, value|
      value.flatten.select { |x| x != key }
    }
  end

  def fetch_tags
    data = fetch "https://github.com/api/v2/json/repos/show/#{URI.escape params[:user]}/#{URI.escape params[:repository]}/tags"

    data['tags'].sort
  end

  alias h escape_html
end
