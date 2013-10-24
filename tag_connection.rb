require 'rubygems'
require 'sinatra'
require 'data_mapper'
require_relative 'idea'
require_relative 'tag'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

def teardown_tag_connections
   Idea.all.destroy
end

class TagConnection
  include DataMapper::Resource  
  
  belongs_to :tag, :key => true
  belongs_to :idea, :key => true
end


