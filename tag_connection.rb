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
  property :id, Serial
  property :idea_id, Integer
  property :tag_id, Integer
  property :created_at, DateTime
  
  # belongs_to :tag
  # belongs_to :idea
end

DataMapper.auto_upgrade!

