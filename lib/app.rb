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
  redirect ("#{params[:user]}/#{params[:repo]}")
end

get "/:user/:repo" do
  no = ghet("http://github.com/api/v2/json/repos/show/#{params[:user]}/#{params[:repo]}/contributors")
  if no.has_key? "error"
    erb :nf
  else  
    erb :repo
  end
end

not_found do
  erb :nf
end
