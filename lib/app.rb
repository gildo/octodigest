require 'sinatra'
require 'json'
require 'haml'
require 'sass'

require 'lib/helpers'

enable :static

views = 'views'

get '/' do
  haml :index
end

post '/' do
  redirect "#{h params[:user]}/#{h params[:repository]}"
end

get '/:user/:repository' do
  @data = fetch "https://github.com/api/v2/json/repos/show/#{h params[:user]}/#{h params[:repository]}/contributors"

  if @data.has_key? 'error'
    @title = 'Not Found...'

    haml :not_found
  else
    @title = "#{h params[:user]}/#{h params[:repository]}"

    haml :repository
  end
end

get '/:user/:repository/:tag' do
  tagger

  if @tcommits.include? 'error'
    @title = 'Not found...'

    haml :not_found
  else
    @title = "#{h params[:user]}/#{h params[:repository]} #{h params[:tag]}"

    haml :tag
  end
end

not_found do
  haml :not_found
end
