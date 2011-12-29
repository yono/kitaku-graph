require 'date'
require 'json'
require 'sinatra'
require 'coffee-script'
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

get '/index.json' do
  content_type :json
  kitakutime = KitakuTime.all(:order => [:target_date.desc])
                         .map{ |data| [data.target_date, data.minute] }
  JSON.unparse(kitakutime)
end
