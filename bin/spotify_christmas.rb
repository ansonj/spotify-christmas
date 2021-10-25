# frozen_string_literal: true

require_relative 'database'
require_relative 'terminal_helpers'

# Primary module, containing the interface and business logic
module SpotifyChristmas
  def self.run(sqlite_path)
    TerminalHelpers.fail_with_message('Please specify a sqlite path.') if sqlite_path.nil?

    db = SCDatabase.new sqlite_path
  end
end
