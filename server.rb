require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'

set :port, 6060

set :database, {adapter: 'sqlite3', database: 'lifely.sqlite3'}

enable :sessions

get '/' do
  erb :home
end

get '/login' do
  erb :login
end

post '/login'do
  user = User.find_by(email: params[:email])
  given_password = params[:password]
  if user.password == given_password
    session[:user_id] = user.id 
    redirect '/'
  else 
    flash[:error] = "Correct email, but wrong password. Did you mean #{user.password}
    only "
    end 
end

get '/logout'do
  session.clear
  redirect '/login'
end

post '/logout' do 
  session.clear
  p "User Logged out Successfully"
  redirect '/login'
end 

get '/signup' do
  erb :signup
end

post '/signup' do
  @user =User.new(params[:user])
  if @user.valid?
    @user.save
    redirect '/profile'
  else
    flash[:error] = @user.errors.full_message
    redirect '/signup'
  end
  p para
end

get '/profile' do
  redirect '/' unless session[:user_id]
  erb :profile
end
