# frozen_string_literal: true

# Provides an interactive menu
module Menu
  # Encapsulates a menu option
  class Option
    attr_accessor :shortcut, :description, :action

    def initialize(shortcut, description, action)
      self.shortcut = shortcut
      self.description = description
      self.action = action
    end
  end

  MENU_SEPARATOR = '-'

  def self.present_menu(options)
    unless options.map(&:shortcut).uniq.count == options.count
      TerminalHelpers.fail_with_message "Developer error: Duplicate shortcuts: #{options}"
    end
    descriptions = options.map { |o| "#{o.shortcut.rjust 4}    #{o.description}" }
    longest_description_length = descriptions.map(&:length).max + 4
    separator = MENU_SEPARATOR * longest_description_length

    puts separator, descriptions, separator

    input = TerminalHelpers.prompt_for_input nil
    matching_options = options.select { |o| o.shortcut == input }
    case matching_options.count
    when 1
      matching_options.first.action.call
    when 0
      puts "No action matching '#{input}'."
    else
      TerminalHelpers.fail_with_message 'Developer error: Reached unreachable code'
    end

    present_menu options
  end
end
