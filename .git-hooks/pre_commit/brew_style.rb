# frozen_string_literal: true

module Overcommit
  module Hook
    module PreCommit
      # Runs `brew style` against any modified Brew files.
      #
      # @see https://docs.brew.sh/Adding-Software-to-Homebrew
      class BrewStyle < Base
        FORMAT_AUDIT_CATEGORIZER = lambda do |type|
          type.match?(/\[correct(?:able|ed)\]/i) ? :warning : :error
        end.freeze

        def run
          result = execute(command, args: applicable_files)
          return :pass if result.success? && !fix?

          audit_messages = result.stdout.split("\n").grep(/^.+?:\d+:\d+:/)
          extract_messages(
            audit_messages,
            /^(?<file>(?:\w:)?[^:]+):(?<line>\d+):[^ ]+ (?<type>\w:(?: \[correct(?:able|ed)\])? [^ ]+:)/i,
            FORMAT_AUDIT_CATEGORIZER,
          )
        end

        def fix?
          config["command"].include?("--fix") || config["flags"].include?("--fix")
        end

        def offenses_corrected?(result)
          return false unless fix?

          result.stdout.match?(/\d+ offense(s)? corrected/)
        end
      end
    end
  end
end
