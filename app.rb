require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'pg'
require './models'

set :port, 6060

set :database, {adapter: 'postgresql', database: 'finalproject', username: 'postgres', password: ENV['POSTGRES_PW']}

enable :sessions

class Article < ActiveRecord::Base

end

get '/' do
    erb :home
end

get '/posts/new' do
    if session['user_id'] == nil
        p 'User was not logged in'
        redirect '/'
    end
    erb :'/posts/new'
end

post '/posts/new' do # CREATE
    p "post published!"
    @post = Post.new(title: params['title'], content: params['content'], user_id: session['user_id'])
    @post.save
    redirect "/posts/#{@post.id}"
end

get '/posts/:id' do # READ
    @post = Post.find(params['id'])
    erb :'/posts/show'
end

get '/posts/?' do
    @posts = Post.all
    erb :'/posts/index'
end

delete '/posts/:id' do # DELETE
    @post = Post.find(params['article_id'])
    @post.destroy
    redirect "/"
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

post '/logout' do
    session[:user_id] = nil
    redirect '/'
end
