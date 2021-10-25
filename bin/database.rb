# frozen_string_literal: true

require 'sqlite3'

# Wrapper for sqlite file access
class SCDatabase
  def initialize(path)
    @path = path
    @db = self.class.create_database @path
    migrate_database
  end

  CONFIG_TABLE_NAME = 'config'
  CONFIG_COLUMN_KEY = 'key'
  CONFIG_COLUMN_VALUE = 'value'
  CONFIG_KEY_DB_VERSION = 'db_version'
  CONFIG_KEY_CLIENT_ID = 'client_id'

  def self.create_database(path)
    database_already_exists = File.readable? path
    db = SQLite3::Database.new path
    unless database_already_exists
      db.execute("CREATE TABLE #{CONFIG_TABLE_NAME} (#{CONFIG_COLUMN_KEY} TEXT, #{CONFIG_COLUMN_VALUE} TEXT)")
      db.execute("INSERT INTO #{CONFIG_TABLE_NAME} VALUES (?, ?)", [CONFIG_KEY_DB_VERSION, 0])
    end
    db
  end

  def migrate_database
    # case database_version
    # when 0
    # CREATE TABLE ...
    # database_version = 1
    # migrate_database if there's a subsequent migration
    # end
  end

  def database_version
    @db.execute("SELECT #{CONFIG_COLUMN_VALUE} FROM #{CONFIG_TABLE_NAME} WHERE #{CONFIG_COLUMN_KEY} = ?", [CONFIG_KEY_DB_VERSION]) do |row|
      return row.first
    end
  end

  def database_version=(new_value)
    @db.execute("UPDATE #{CONFIG_TABLE_NAME} SET #{CONFIG_COLUMN_VALUE} = ? WHERE #{CONFIG_COLUMN_KEY} = ?", [new_value, CONFIG_KEY_DB_VERSION])
  end
end
