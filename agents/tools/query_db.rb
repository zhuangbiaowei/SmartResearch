require "sequel"
=begin
SmartAgent::Tool.define_group :query_db do
  desc "Provides read-only access to PostgreSQL databases."
  param_define :db_url, "postgresql url with `postgresql://user:password@host:port/db-name`", :string
  define :get_schema do
    DB = Sequel.connect(params["db_url"])
    DB.fetch("SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_name in (select tablename from pg_tables where schemaname='public') ORDER BY table_name")
  end

  define :sql_query do
    DB = Sequel.connect(params["db_url"])
    param_define :sql, "SQL statement to query the database", :string
    DB.fetch(input_params["sql"])
  end
end
=end
