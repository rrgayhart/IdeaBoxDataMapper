require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Idea
  include DataMapper::Resource  
  property :id, Serial
  property :title, String
  property :description, String
  property :rank, Integer
  property :completed_at, DateTime

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
