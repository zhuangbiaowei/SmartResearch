require "sequel"
require "pg"

# 数据库连接配置
DB = Sequel.connect("postgres://nr:search@localhost/new_research")

# 数据库工具类
class Database
  # 加载所有模型文件
  # 自动加载 models 目录下的所有 .rb 文件
  def self.load_models
    model_dir = File.join(File.dirname(__FILE__), "models")

    # 检查模型目录是否存在
    unless Dir.exist?(model_dir)
      raise "模型目录不存在: #{model_dir}"
    end

    # 获取所有 .rb 文件并排序以确保一致的加载顺序
    model_files = Dir.glob(File.join(model_dir, "*.rb")).sort

    # 逐个加载模型文件
    model_files.each do |file|
      begin
        require_relative file
      rescue LoadError => e
        puts "警告: 无法加载模型文件 #{file}: #{e.message}"
      end
    end
  end

  def self.setup
    # 创建扩展（如果不存在）
    DB.run("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")

    # 检查表是否存在
    tables = DB.tables

    # 如果没有表，运行初始化脚本
    unless tables.include?(:tags)
      sql = File.read("db/init.sql")
      DB.run(sql)
      puts "数据库表已创建"
    else
      puts "数据库表已存在"
    end
  end

  def self.test_connection
    DB.test_connection
  end

  def self.disconnect
    DB.disconnect
  end
end

# 加载所有模型
Database.load_models

# 设置Sequel配置
Sequel::Model.plugin :validation_helpers
