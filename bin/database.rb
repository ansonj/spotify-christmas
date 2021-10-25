# frozen_string_literal: true

require 'sqlite3'
require_relative 'terminal_helpers'

# Wrapper for sqlite file access
class SCDatabase
  def initialize(path)
    @path = path
    @db = self.class.create_database @path

    migrate_database

    if client_id.nil?
      self.client_id = TerminalHelpers.prompt_for_input 'Please enter your Spotify client ID.'
    end
    if client_secret.nil?
      self.client_secret = TerminalHelpers.prompt_for_input 'Please enter your Spotify client secret.'
    end
  end

  CONFIG_TABLE_NAME = 'config'
  CONFIG_COLUMN_KEY = 'key'
  CONFIG_COLUMN_VALUE = 'value'
  CONFIG_KEY_DB_VERSION = 'db_version'
  CONFIG_KEY_CLIENT_ID = 'client_id'
  CONFIG_KEY_CLIENT_SECRET = 'client_secret'

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
    case database_version.to_i
    when 0
      [CONFIG_KEY_CLIENT_ID, CONFIG_KEY_CLIENT_SECRET].each do |key|
        @db.execute("INSERT INTO #{CONFIG_TABLE_NAME} VALUES (?, ?)", [key, nil])
      end
      self.database_version = 1
      # When a new migation is added, call migrate_database again at the end of the previous case
    end
  end

  def read_config_value(key)
    @db.execute("SELECT #{CONFIG_COLUMN_VALUE} FROM #{CONFIG_TABLE_NAME} WHERE #{CONFIG_COLUMN_KEY} = ?", [key]) do |row|
      return row.first
    end
  end

  def write_config_value(key, value)
    @db.execute("UPDATE #{CONFIG_TABLE_NAME} SET #{CONFIG_COLUMN_VALUE} = ? WHERE #{CONFIG_COLUMN_KEY} = ?", [value, key])
  end

  def database_version
    read_config_value CONFIG_KEY_DB_VERSION
  end

  def database_version=(new_value)
    write_config_value CONFIG_KEY_DB_VERSION, new_value
  end

  def client_id
    read_config_value CONFIG_KEY_CLIENT_ID
  end

  def client_id=(new_value)
    write_config_value CONFIG_KEY_CLIENT_ID, new_value
  end

  def client_secret
    read_config_value CONFIG_KEY_CLIENT_SECRET
  end

  def client_secret=(new_value)
    write_config_value CONFIG_KEY_CLIENT_SECRET, new_value
  end
end
