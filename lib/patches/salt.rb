# typed: strict
# frozen_string_literal: true

module Patches
  # Patches for Salt recipes
  module Salt
    extend SystemCommand::Mixin

    def self.patch_plist(daemon)
      plist_file = "/Library/LaunchDaemons/com.saltstack.salt.#{daemon}.plist"
      xml, status = system_command "plutil",
                                   args: ["-convert", "xml1", "-o", "-", "--", plist_file],
                                   sudo: true

      return unless status.success?

      xml = Plist.parse_xml(xml)

      xml["EnvironmentVariables"] = {} unless xml.key?("EnvironmentVariables")
      xml["EnvironmentVariables"]["HOMEBREW_PREFIX"] = HOMEBREW_PREFIX.to_s
      xml["EnvironmentVariables"]["HOME"] ||= "/var/root"

      path = xml["EnvironmentVariables"]["PATH"] || "/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      path = "#{HOMEBREW_PREFIX}/bin:#{path}" unless path.split(":").include?("#{HOMEBREW_PREFIX}/bin")
      xml["EnvironmentVariables"]["PATH"] = path

      random_str = (0...8).map { rand(65..90).chr }.join
      new_plist_file = "/tmp/#{random_str}.#{File.basename(plist_file)}"
      File.write(new_plist_file, xml.to_plist)
      system_command "plutil",
                     args: ["-lint", new_plist_file]

      system_command "mv",
                     args: [new_plist_file, plist_file],
                     sudo: true
      system_command "chown",
                     args: ["root:wheel", plist_file],
                     sudo: true
    end
  end
end
