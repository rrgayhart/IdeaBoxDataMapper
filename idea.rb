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

  def like!
    @rank ||= 0
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end

post '/idea/create' do
  idea = Idea.new(:title => params[:title], :description => params[:description])
  if idea.save
    status 201
    redirect '/idea/'+idea.id.to_s
  else
    status 412
    redirect '/ideas'
  end
end

get '/idea/:id' do
  @idea = Idea.get(params[:id])
  erb :edit
end

get '/' do
  @ideas = Idea.all
  erb :index
end


get '/idea/:id/edit' do
  @idea = Idea.get(params[:id])
  erb :edit
end


put '/idea/:id' do
  idea = Idea.get(params[:id])
  idea.completed_at = params[:completed] ?  Time.now : nil
  idea.title = (params[:title])
  idea.description = (params[:description])
  if idea.save
    status 201
    redirect '/idea/'+idea.id.to_s
  else
    status 412
    redirect '/ideas'   
  end
end

get '/idea/:id/delete' do
  @idea = Idea.get(params[:id])
  erb :delete
end

delete '/idea/:id' do
  Idea.get(params[:id]).destroy
  redirect '/ideas'  
end



DataMapper.auto_upgrade!
