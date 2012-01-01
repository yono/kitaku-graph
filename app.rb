require 'date'
require 'json'
require 'sinatra'
require 'erb'
require 'dm-core'
require 'dm-migrations'

DataMapper::setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db.sqlite3')

class KitakuTime
  include DataMapper::Resource
  property :id, Serial
  property :minute, Integer
  property :target_date, Date
  auto_upgrade!
end

get '/' do
  erb :index
end

post '/' do
  kitakutime = KitakuTime.create(:minute => params[:minute],
                                 :target_date => params[:target_date])
end

get '/index.json' do
  content_type :json
  kitakutime = KitakuTime.all(:order => [:target_date.desc])
                         .map{ |data| [data.target_date, data.minute] }
  JSON.unparse(kitakutime)
end
