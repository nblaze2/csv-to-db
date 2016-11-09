require 'pg'
require 'csv'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  CSV.foreach('ingredients.csv') do |row|
    conn.exec_params(
        'INSERT INTO ingredients (item_num, ingredient) VALUES($1, $2)',
        [row[0], row[1]]
    )
  end
end

db_connection do |conn|
  results = conn.exec('SELECT * FROM ingredients;')
  results.each do |item|
    puts "#{item["item_num"]}. #{item["ingredient"]}"
  end
end
