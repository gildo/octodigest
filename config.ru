require 'sinatra'

unless $:.unshift(File.dirname(__FILE__)) and require 'lib/app'
	fail 'could not require needed files'
end

run Sinatra::Application
