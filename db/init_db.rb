require "sequel"
DB = Sequel.connect("postgres://nr:search@localhost/new_research")

# 获取数据库中所有表名并删除
puts "⏳ 正在清空数据库表..."
table_names = DB.fetch("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'").map(:table_name)
table_names.each do |table_name|
  DB.run("DROP TABLE IF EXISTS #{table_name} CASCADE")
  puts "🗑️  已删除表: #{table_name}"
end
puts "✅ 数据库表已清空。"

sql_file_path = "db/init.sql"
sql = File.read(sql_file_path)
sql.split(/;\s*$/).each do |statement|
  next if statement.strip.empty?
  DB.run(statement)
end
puts "✅ 数据库初始化完成。"
