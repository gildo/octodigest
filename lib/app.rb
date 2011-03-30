require 'sinatra'
require 'padrino-core/application/rendering'
require 'render'
require 'json'

class Octodigest < Sinatra::Application
  register Padrino::Rendering

  set :views,  'views'
  enable :static
 
  after { settings.views = 'views' }

  helpers do
    require './lib/helpers'
  end

  get "/" do
    render index
  end

  post "/" do
    redirect ("#{h params[:user]}/#{h params[:repo]}")
  end

  get "/:user/:repo" do
    @data = ghet("http://github.com/api/v2/json/repos/show/#{h params[:user]}/#{h params[:repo]}/contributors")
    if @data.has_key? "error"
      @title = "Not Found..."
      render :nf
    else
      @title = "#{h params[:user]}/#{h params[:repo]}"
      render :repo
    end
  end

  get "/:user/:repo/:tag" do
    tagger
    if @tcommits.include? "error"
      @title = "Not found..."
      render :nf
    else
      @title = "#{h params[:user]}/#{h params[:repo]} #{h params[:tag]}"
      render :tag
    end
  end

  not_found do
    render :nf
  end

end
