cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.3"
  sha256 arm:   "370018cf745a1b56592eff34dc66884b692bd6447be4f6010525cba83fbe972d",
         intel: "370018cf745a1b56592eff34dc66884b692bd6447be4f6010525cba83fbe972d"

  #url "https://repo.saltproject.io/salt/py3/macos/minor/#{version}/salt-#{version}-py3-#{arch}.pkg"
  url "https://repo.saltproject.io/salt/py3/macos/minor/#{version}/salt-#{version}-py3-x86_64.pkg"
  name "Salt"
  desc "World's fastest, most intelligent and scalable automation engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://repo.saltproject.io/salt/py3/macos/latest"
    regex(/salt-(\d+(?:\.\d+)?(?:-\d+)?)-py3-#{arch}\.pkg/)
  end

  conflicts_with formula: "salt"
  depends_on arch: :x86_64

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
    random_str = (0...8).map { rand(65..90).chr }.join
    %w[api master minion syndic].each do |daemon|
      plist_file = "/Library/LaunchDaemons/com.saltstack.salt.#{daemon}.plist"
      xml, = system_command! "plutil",
                             args: ["-convert", "xml1", "-o", "-", "--", plist_file],
                             sudo: true
      xml = Plist.parse_xml(xml)

      xml["EnvironmentVariables"] = {} unless xml.key?("EnvironmentVariables")
      xml["EnvironmentVariables"]["HOMEBREW_PREFIX"] = HOMEBREW_PREFIX.to_s

      path = xml["EnvironmentVariables"]["PATH"] || "/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      path = "#{HOMEBREW_PREFIX}/bin:#{path}" unless path.split(":").include?("#{HOMEBREW_PREFIX}/bin")
      xml["EnvironmentVariables"]["PATH"] = path

      new_plist_file = "/tmp/#{random_str}.#{File.basename(plist_file)}"
      File.write(new_plist_file, xml.to_plist)
      system_command! "plutil",
                      args: ["-lint", new_plist_file]

      system_command! "mv",
                      args: [new_plist_file, plist_file],
                      sudo: true
      system_command! "chown",
                      args: ["root:wheel", plist_file],
                      sudo: true
    end
  end

  uninstall pkgutil:   [
              "com.saltstack.salt",
            ],
            launchctl: [
              "com.saltstack.salt.*",
            ]

  zap trash: [
    "/etc/salt",
  ]

  def caveats
    <<~CAVEATS
      After installation, configure the Salt minion ID, and the Salt master location,
      replacing the placeholder text with custom information:

      sudo salt-config -i [MINION_ID] -m [SALT_MASTER_HOST]

      See Configure the Salt master and minions for more configuration options:
      https://docs.saltproject.io/salt/install-guide/en/latest/topics/configure-master-minion.html

      Load services you need:

      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.api
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.master
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.minion
      sudo launchctl load -w /Library/LaunchDaemons/com.saltstack.salt.syndic
    CAVEATS
  end
end
