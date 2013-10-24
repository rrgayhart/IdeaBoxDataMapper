$:.unshift File.expand_path("/", __FILE__)
require 'bundler'
Bundler.require
require 'engine'
#run Sinatra::Application
run IdeaBoxApp
