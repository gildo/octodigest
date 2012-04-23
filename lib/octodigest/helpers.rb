require 'net/http'
require 'net/https'
require 'json'

helpers do
  include Rack::Utils

  def fetch (uri)
    uri  = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    body = http.get(uri.to_s).body

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

    @tag.commits = fetch "https://api.github.com/repos/#{params[:user]}/#{params[:repository]}/commits?sha=#{params[:tag]}&per_page=50"
    if @tag.commits.include? 'error'
      return
    end

    @tag.commits_per_author = Hash[@tag.commits].map {|x|
      [x['author']['login'], x['author']['id']]
    }.group_by { |(name, _)| name }.each {|key, value|
      value.flatten.select { |x| x != key }
    }
  end

  def fetch_tags    
    data = fetch "https://api.github.com/repos/#{URI.escape params[:user]}/#{URI.escape params[:repository]}/tags"
    
    # let's get also
    tags = data.map { |x| [x["name"], x["commit"]["sha"]] }
    Hash[tags.sort!]
  end

  alias h escape_html
end
