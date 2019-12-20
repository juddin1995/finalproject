require 'sinatra/activerecord'
require 'sinatra'

set :port, 6060

set :database, {adapter: 'sqlite3', database: 'lifely.sqlite3'}

get '/' do
  erb :home
end

