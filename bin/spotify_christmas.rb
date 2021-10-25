# frozen_string_literal: true

require_relative 'database'

# Primary module, containing the interface and business logic
module SpotifyChristmas
  def self.run(sqlite_path)
    fail_with_message('Please specify a sqlite path.') if sqlite_path.nil?

    db = SCDatabase.new sqlite_path
  end

  def self.fail_with_message(message)
    puts message
    exit 1
  end
end
