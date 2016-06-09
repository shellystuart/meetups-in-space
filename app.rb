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

def show_join?(meetup, user)
  !meetup.users.include?(user) && meetup.creator != user
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
    errors = @new_meetup.errors.full_messages.first
    count = @new_meetup.errors.full_messages.count
    @new_meetup.errors.full_messages[1..count].each do |message|
      errors += ", #{message}"
    end
    flash[:notice] = errors
    flash[:name] = @new_meetup.name
    flash[:location] = @new_meetup.location
    flash[:description] = @new_meetup.description
    redirect '/meetups/new'
  end
end


get '/meetups/:id' do
  @meetup_info = Meetup.find(params[:id])
  @attendees = @meetup_info.users
  erb :'meetups/show'
end

post '/meetups/:id' do
  meetup_id = params[:id]
  new_attendee = Attendee.new(user: current_user, meetup_id: meetup_id)
  if new_attendee.valid?
    new_attendee.save
    redirect "/meetups/#{meetup_id}"
  else
    flash[:notice] = "Please sign in"
    redirect "/meetups/#{meetup_id}"
  end
end
