require 'sinatra'
require_relative 'config/application'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order(name: :asc)
  erb :'meetups/index'
end

get '/meetups/new' do
  @new_meetup = Meetup.new
  erb :'meetups/new'
end

post '/meetups/new' do
  @new_meetup = Meetup.new(name: params["name"], location: params["location"], description: params["description"], creator: current_user)
  if @new_meetup.valid?
    @new_meetup.save
    flash[:notice] = "Meetup created successfully!"
    redirect "/meetups/#{@new_meetup.id}"
  else
    flash[:notice] = @new_meetup.errors.full_messages
    erb :'meetups/new'
  end
end


get '/meetups/:id' do
  @meetup_info = Meetup.find(params[:id])
  erb :'meetups/show'
end

post '/meetups/:id' do
  redirect '/meetups/:id'
end
