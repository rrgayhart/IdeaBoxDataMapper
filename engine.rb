require 'rubygems'
require 'sinatra'
require 'data_mapper'
require_relative 'idea'
require_relative 'tag'
require_relative 'tag_connection'

get '/' do
  @ideas = Idea.all
  erb :index
end

#Idea Section

post '/idea/create' do
  idea = Idea.new(:title => params[:title], :description => params[:description], :created_at => Time.now)
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



# Tag Section

get '/tags' do
  @tags = Tag.all
  erb :tags
end

put '/tag/:id' do
  tag = Tag.get(params[:id])
  tag.title = (params[:title])
  if tag.save
    status 201
    redirect '/tags'
    #redirect '/tag/'+tag.id.to_s
  else
    status 412
    redirect '/tags'   
  end
end

post '/tag/create' do
  @tags = Tag.all
  @tags.each do |row|
    if row.title.downcase == params[:title].downcase
      tag = row
      redirect '/tags'
      break
    else
      tag = Tag.new(:title => params[:title])
      tag.save
      redirect '/tags'
    end
  end
end

get '/tag/:id/delete' do
  @tag = Tag.get(params[:id])
  erb :delete_tag
end

get '/tag/:id' do
  @tag = Tag.get(params[:id])
  erb :tag_show
end

delete '/tag/:id' do
  Tag.get(params[:id]).destroy
  redirect '/tags'  
end

# Tag Connection Section
post '/tag_connection/create' do
  tag_connection = TagConnection.new(:idea_id => params[:idea_id], :tag_id => params[:tag_id], :created_at => Time.now)
    if tag_connection.save
    status 201
    redirect '/tags'
    #redirect '/tag/'+tag.id.to_s
  else
    status 412
    redirect '/tags'
  end
end


