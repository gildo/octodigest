require 'sinatra'
require 'erb'

set :views,  'views'
enable :static

helpers do
  require './lib/helpers'
end

get "/" do
  erb :index
end

post "/" do
  redirect ("#{params[:user]}/#{params[:repo]}")
end

get "/:user/:repo" do
  user = params[:user]
  repo = params[:repo]
  erb :repo
  #ghet "http://github.com/api/v2/json/repos/show/#{params[:user]}/#{params[:repo]}/contributors"
end              
