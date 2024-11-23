module Utils
  extend SystemCommand::Mixin

  def self.patch_plist(daemon)
    plist_file = "/Library/LaunchDaemons/com.saltstack.salt.#{daemon}.plist"
    xml, _, status = system_command "plutil",
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

cask "salt@3006" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.9"
  sha256 arm:   "81fca1bcd46eed09a6f5b97451a1238a6a78a97a1af6757cf6a73b2bb7b6db6d",
         intel: "5366e96e38073863522c2fc8097c97f7698a84c22f9899cbdf796b1e8b45b1e0"

  url "https://packages.broadcom.com/artifactory/saltproject-generic/macos/#{version}/salt-#{version}-py3-#{arch}.pkg",
      verified: "packages.broadcom.com/artifactory/saltproject-generic/"
  name "Salt #{version} LTS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://packages.broadcom.com/artifactory/saltproject-generic/macos"
    regex(%r{href="3006\.\d+/">(3006\.\d+)}i)
  end

  conflicts_with formula: "salt"

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
    require_relative "#{`brew --repository cdalvaro/tap`.lines.first.chomp}/lib/patches/salt"
    %w[api master minion syndic].each { |daemon| Utils.patch_plist(daemon) }
  end

  uninstall launchctl: [
              "com.saltstack.salt.api",
              "com.saltstack.salt.master",
              "com.saltstack.salt.minion",
              "com.saltstack.salt.syndic",
            ],
            pkgutil:   "com.saltstack.salt"

  zap trash: "/etc/salt"

  def caveats
    <<~CAVEATS
      Included services:

      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.api.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.master.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.minion.plist
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.syndic.plist
    CAVEATS
  end
end
