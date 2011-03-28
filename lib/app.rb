require 'sinatra'
require 'erb'

set :views,  'views'
set :public, 'public'

get "/" do
  erb :index
end

post "/" do
  redirect ("#{params[:user]} LOl/LOL #{params[:repo]}")
end

get "/:user/:repo" do
  params[:user] + " " + params[:repo]
end              
