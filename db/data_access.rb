
def run_sql(sql)
    db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'my_eleven'})
    results = db.exec(sql)
    db.close
    return results
end

def find_user_by_email(email)
    results = run_sql("select * from users where email = '#{email}';")
    return results[0]
end

def find_user_by_id(id)
    results = run_sql("select * from users where id = #{id};")
    return results[0]
end