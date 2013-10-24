require 'rubygems'
require 'sinatra'
require 'data_mapper'
require_relative 'idea'
require_relative 'tag'
require_relative 'tag_connection'


#change this to auto_migrate! in order to clear out the database
configure :development do
  DataMapper.auto_upgrade!
end

get '/' do
  @ideas = Idea.all(:limit => 4, :order => [:created_at.desc])
  @tags = Tag.all
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc]) 
  erb :index
end

#Idea Section
get '/ideas' do
  @ideas = Idea.all(:order => [:created_at.asc])
  @tags = Tag.all
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
  @completed_ideas = Idea.all(:limit => 5, :completed_at => true, :order => [:completed_at.desc])
  erb :ideas
end

post '/idea/create' do
  idea = Idea.new(:title => params[:title], :description => params[:description], :created_at => Time.now)
  tag_ideas(params[:tag].downcase.split(","), idea)
  if idea.save
    status 201
    redirect '/idea/'+idea.id.to_s
  else
    status 412
    redirect '/'
  end
end

def tag_ideas(tags, idea)
    tags.each do |tag_title|
    tag = Tag.first_or_new(:title => tag_title.strip)
    idea.tags << tag
  end
end

get '/idea/:id' do
  @tags = Tag.all
  @idea = Idea.get(params[:id])
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
  erb :edit
end


get '/idea/:id/edit' do
  @tags = Tag.all
  @idea = Idea.get(params[:id])
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
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
  @tags = Tag.all
  @idea = Idea.get(params[:id])
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
  erb :delete
end

delete '/idea/:id' do
  Idea.get(params[:id]).destroy
  redirect '/'  
end



# Tag Section

get '/tags' do
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
  @tags = Tag.all
  erb :tags
end

put '/tag/:id' do
  @tags = Tag.all
  @ideas = Idea.all
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
  tag = Tag.new(:title => params[:title])
  if tag.save
    status 201
    redirect '/tag/'+tag.id.to_s
  else
    status 412
    redirect '/tags'
  end
end

get '/tag/:id/delete' do
  @tag = Tag.get(params[:id])
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
  erb :delete_tag
end

get '/tag/:id' do
  @tag = Tag.get(params[:id])
  @sidebar_tags = Tag.all(:limit => 6, :order => [:created_at.desc])
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



