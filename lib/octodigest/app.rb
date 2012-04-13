enable :static

set :app_file, __FILE__

dir = File.dirname(__FILE__)
set :public_folder, "#{dir}/public"



get '/' do
  haml :index
end

post '/' do
  redirect "/#{URI.escape params[:user]}/#{URI.escape params[:repository]}"
end

get '/:user/:repository' do
  data = fetch "https://github.com/api/v2/json/repos/show/#{URI.escape params[:user]}/#{URI.escape params[:repository]}/contributors"

  if data.has_key? 'error'
    @title = 'Not Found...'

    haml :not_found
  else
    populate data

    @title = "#{params[:user]}/#{params[:repository]}"
    @tags  = fetch_tags

    haml :repository
  end
end

get '/:user/:repository/:tag' do
  tagger

  data = fetch "https://github.com/api/v2/json/repos/show/#{URI.escape params[:user]}/#{URI.escape params[:repository]}/contributors"

  if data.has_key? 'error' or @tag.commits.include? 'error'
    @title = 'Not found...'

    haml :not_found
  else
    populate data

    @title = "#{params[:user]}/#{params[:repository]} #{params[:tag]}"
    @tags  = fetch_tags

    haml :tag
  end
end

not_found do
  haml :not_found
end
