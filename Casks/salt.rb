module Utils
  extend SystemCommand::Mixin

  def self.patch_plist(daemon)
    plist_file = "/Library/LaunchDaemons/com.saltstack.salt.#{daemon}.plist"
    xml, = system_command "plutil",
                          args: ["-convert", "xml1", "-o", "-", "--", plist_file],
                          sudo: true
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

cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.7"
  sha256 arm:   "022060c90a576754c5a720b6f007d7ea5a42ca50bdce4fa4c8cf68107f5f7885",
         intel: "03cf7815af813046542b7744b80ec24d48a95df4d75a5b77bdd3f5ab3c4dec92"

  url "https://repo.saltproject.io/salt/py3/macos/minor/#{version}/salt-#{version}-py3-#{arch}.pkg"
  name "Salt"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://repo.saltproject.io/salt/py3/macos/latest"
    regex(/salt[._-]v?(\d+(?:\.\d+)+)-py3-#{arch}\.pkg/)
  end

  conflicts_with formula: "salt"

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
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
