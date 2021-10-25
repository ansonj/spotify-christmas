# frozen_string_literal: true

# Helper methods for terminal I/O and interactivity
module TerminalHelpers
  def self.fail_with_message(message)
    puts message
    exit 1
  end

  def self.prompt_for_input(message)
    puts message
    print '> '
    $stdin.gets.chomp
  end
end
