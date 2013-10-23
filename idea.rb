require 'rubygems'
require 'sinatra'
require 'data_mapper'
require_relative 'tag'
require_relative 'tag_connection'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

def teardown_idea
   Idea.all.destroy
end

class Idea
  include DataMapper::Resource  
  property :id, Serial
  property :title, String
  property :description, String
  property :rank, Integer
  property :completed_at, DateTime

  # has n, :tag_connections
  # has n, :tags, :through => :tag_connections

  def completed?
    true if completed_at
  end

  def self.completed
    all(:completed_at.not => nil)
  end

  def link
    "<a href=\"idea/#{self.id}\">#{self.title}</a>" 
  end

  def like!
    @rank ||= 0    
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end


DataMapper.auto_upgrade!
