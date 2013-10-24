require 'rubygems'
require 'sinatra'
require 'data_mapper'
require_relative 'idea'
require_relative 'tag_connection'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

def teardown_tag
   Idea.all.destroy
end

class Tag
  include DataMapper::Resource  
  property :id, Serial
  property :title, String, :required => true, :unique => true

  has n, :tag_connections
  has n, :ideas, :through => :tag_connections

end

