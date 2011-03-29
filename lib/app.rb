require 'sinatra'
require 'erb'
require 'json'

set :views,  'views'
enable :static

helpers do
  require './lib/helpers'
end

get "/" do
  erb :index
end

post "/" do
  redirect ("#{h params[:user]}/#{h params[:repo]}")
end

get "/:user/:repo" do
  @data = ghet("http://github.com/api/v2/json/repos/show/#{h params[:user]}/#{h params[:repo]}/contributors")
  if @data.has_key? "error"
    @title = "Not Found..."
    erb :nf
  else
    @title = "#{h params[:user]}/#{h params[:repo]}"
    erb :repo
  end
end

not_found do
  erb :nf
end
