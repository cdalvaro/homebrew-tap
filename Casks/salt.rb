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

  version "3007.0"
  sha256 arm:   "f43a71ef5455f86cc67512886918be798415a87edd0780f7475de06f772cc76b",
         intel: "559d46cfee21c6d69234b1f3c1020cbc1800ccd447ddaf8ae16aaa4f7f320be0"

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
