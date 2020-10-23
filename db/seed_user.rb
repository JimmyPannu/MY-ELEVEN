require 'bcrypt'
require 'pg'


require_relative 'data_access.rb'

email = 'jeff@ga.com'

password_digest = BCrypt::Password.create('cricket')

sql = "INSERT INTO users (email, password_digest) VALUES ('#{email}', '#{password_digest}');"
run_sql(sql)