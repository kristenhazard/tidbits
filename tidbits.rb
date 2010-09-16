require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/tidbits.db")

class Topic
  
  include DataMapper::Resource
  
  property :id,           Serial
  property :name,         String
  property :description,  String  
  property :url,          String
  property :is_active,    Boolean
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
end


configure :development do
  # Create or upgrade all tables at once, like magic
  DataMapper.auto_upgrade!
end

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

#landing page
get '/' do
  erb :index
end

# list topics
get '/list' do
  @page_title = "Topics"
  @topics = Topic.all(:order => [:created_at.desc])
  erb :list
end

# new topic
get '/new' do
  @page_title = "New Topic"
  erb :new
end

get '/show/:id' do
  @topic = Topic.get(params[:id])
  if @topic
    erb :show
  else
    redirect('/list')
  end
end

post '/create' do
  @topic = Topic.new(params[:topic])
  if @topic.save
    redirect "/show/#{@topic.id}"
  else
    redirect('/list')
  end
end

get '/delete/:id' do
  topic = Topic.get(params[:id])
  topic.destroy unless topic.nil?
  redirect('/list')
end
