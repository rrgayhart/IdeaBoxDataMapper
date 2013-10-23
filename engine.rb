require 'rubygems'
require 'sinatra'
require 'data_mapper'
require_relative 'idea'
require_relative 'tag'
require_relative 'tag_connection'


get '/tags' do
  @tags = Tag.all
  erb :tags
end

post '/tag/create' do
  tag = Tag.new(:title => params[:title])
  if tag.save
    status 201
    redirect '/tag/'+tag.id.to_s
  else
    status 412
    redirect '/tags'
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
  redirect '/'  
end

