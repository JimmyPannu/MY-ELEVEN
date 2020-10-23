     
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'bcrypt'
require_relative 'db/data_access.rb' if development?
enable :sessions

def logged_in?()

  if session[:user_id]
    true
  else
    false
  end

end


def current_user()
  find_user_by_id(session[:user_id])
end


def run_sql(sql)
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'my_eleven'})
  results = db.exec(sql)
  db.close
  return results
end


get '/' do

  players = run_sql("SELECT * FROM players")

  erb :index, locals: {
    players: players
  }

end

get '/players/new' do

  erb :new

end

get '/players/:id' do

  sql = "SELECT * FROM players WHERE id = #{ params['id'] };"

  results = run_sql(sql)

  erb :details, locals: { player: results[0] }

end

post '/players' do 
  redirect '/login' unless  logged_in?
  sql = "INSERT INTO players (name, image_url, age, team, playing_role) VALUES ('#{params["name"]}', '#{params["image_url"]}', '#{params["age"]}', '#{params["team"]}', '#{params["playing_role"]}');"

  results = run_sql(sql)

  redirect "/"
end

delete '/players/:id' do

  sql = "DELETE FROM players WHERE id = #{ params['id'] };"

  results = run_sql(sql)

  redirect "/"

end

get '/players/:id/edit' do
  
  sql = "SELECT * FROM players WHERE id = #{params['id']};"

  results = run_sql(sql)


  erb :edit, locals: { player: results[0] }

end

patch '/players/:id' do

  sql = "UPDATE players SET name = '#{params['name']}', image_url = '#{params['image_url']}', age = '#{params['age']}', team = '#{params['team']}', playing_role = '#{params['playing_role']}' WHERE id = '#{params['id']}';"

  results = run_sql(sql)

  redirect "/players/#{params['id']}"

end

get '/login' do

  erb :login

end

post '/login' do

  # params['email'] = 'jim@ga.com'
  # params['password'] = 'cricket'
  # results = run_sql("select * from users where email = '#{params['email']}';")
  # redirect '/'
  # erb :login
  # user = results[0]
  user = find_user_by_email(params['email'])
  # user.to_a.to_s

  if BCrypt::Password.new(user['password_digest']) == params['password']
    session[:user_id] = user['id']
    redirect "/"
  else
    erb :login
  end

end

delete '/logout' do

  session[:user_id] = nil

  redirect'/login'

end
