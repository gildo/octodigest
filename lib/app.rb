require 'padrino-core/application/rendering'
require 'json'

class Octodigest < Sinatra::Base
  register Padrino::Rendering

  set :public, File.join(File.dirname(__FILE__), '..', 'public')
  views = './views'
  templates[:layout] = File.read(File.join(views, 'layout.erb'))

  get "/" do
    render :index
  end

  post "/" do
    redirect("#{h params[:user]}/#{h params[:repo]}")
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

require './lib/helpers'
