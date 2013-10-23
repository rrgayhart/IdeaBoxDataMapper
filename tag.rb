require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Tag
  include DataMapper::Resource  
  property :id, Serial
  property :title, String
  property :idea_id, Integer

end

DataMapper.auto_upgrade!
