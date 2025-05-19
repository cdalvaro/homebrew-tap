# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  class BrewStyle < Base

    FORMAT_AUDIT_CATEGORIZER = lambda do |type|
      type.match?(/\[correct(?:able|ed)\]/i) ? :warning : :error
    end

    def run
      result = execute(command, args: applicable_files)
      return :pass if result.success? && !fix?

      audit_messages = result.stdout.split("\n").select { |line| line.match?(/^.+?:\d+:\d+:/) }
      audit_messages = extract_messages(
        audit_messages,
        /^(?<file>(?:\w:)?[^:]+):(?<line>\d+):[^ ]+ (?<type>\w:(?: \[correct(?:able|ed)\])? [^ ]+:)/i,
        FORMAT_AUDIT_CATEGORIZER
      )

      audit_messages
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
