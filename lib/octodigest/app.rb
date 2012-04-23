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
  @data = fetch "https://api.github.com/repos/#{URI.escape params[:user]}/#{URI.escape params[:repository]}/contributors"

  if @data[0].has_key? 'error'
    @title = 'Not Found...'

    haml :not_found
  else
    @title = "#{params[:user]}/#{params[:repository]}"
    @tags  = fetch_tags

    haml :repository
  end
end

get '/:user/:repository/:tag' do
  @tags  = fetch_tags
  tagger

  #data = fetch "https://api.github.com/repos/#{URI.escape params[:user]}/#{URI.escape params[:repository]}/contributors"

  if @tag.commits.include? 'error'
    @title = 'Not found...'

    haml :not_found
  else

    @title = "#{params[:user]}/#{params[:repository]} #{params[:tag]}"
    @tags  = fetch_tags

    haml :tag
  end
end

not_found do
  haml :not_found
end
