require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'pg'
require './models'

set :port, 6060

set :database, {adapter: 'postgresql', database: 'finalproject', username: 'postgres', password: ENV['POSTGRES_PW']}

enable :sessions

get '/' do
    erb :home
end

post '/' do
    @post = Post.new(params[:content])
    if @post.valid?
        pp @post
        @post.save
        redirect '/'
    else
        flash[:errors] = @post.errors.full_messages
        redirect '/signup'
    end
end

get '/login' do
    erb :login
end

post '/login' do
    user = User.find_by(email: params[:email])
    given_password = params[:password]
    puts user
    if user.password == given_password
        session[:user_id] = user.id
        redirect '/profile'
    else
        flash[:error] = "Correct email but wrong password. did you mean #{user.password} 
        \ Only use this password if this is your account"
        redirect '/login'
    end
end

get '/signup' do
    erb :signup
end

post '/signup' do
    @user = User.new(params[:user])
    if @user.valid?
        puts @user
        @user.save
        redirect '/login'
    else
        flash[:errors] = @user.errors.full_messages
        redirect '/signup'
    end
end

get '/profile' do
    if session[:user_id] 
        erb :profile
    end
end

get '/logout' do
    session[:user_id] = nil
    redirect '/'
end