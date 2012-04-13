require 'sinatra'

unless $LOAD_PATH.unshift(File.expand_path("../lib", __FILE__)) and require 'octodigest'
	fail 'could not require needed files'
end

run Sinatra::Application
