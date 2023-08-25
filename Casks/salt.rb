cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3006.2"
  sha256 arm:   "",
         intel: "1dec46d448a0b4c46079928c82e9d6e907d3b858c280764730a06aacdb458b59"

  url "https://repo.saltproject.io/salt/py3/macos/minor/#{version}/salt-#{version}-py3-#{arch}.pkg"
  name "Salt"
  desc "World's fastest, most intelligent and scalable automation engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://repo.saltproject.io/salt/py3/macos/latest"
    regex(%r{salt-(\d+(?:\.\d+)?(?:-\d+)?)-py3-#{arch}\.pkg})
  end

  conflicts_with formula: "salt"
  depends_on arch: :x86_64

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
    %w[api master minion syndic].each do |daemon|
      plist_file = "/Library/LaunchDaemons/com.saltstack.salt.#{daemon}.plist"
      xml, = system_command! "plutil",
                             args: ["-convert", "xml1", "-o", "-", "--", plist_file],
                             sudo: true
      xml = Plist.parse_xml(xml)

      xml["EnvironmentVariables"] = {} unless xml.key?("EnvironmentVariables")

      xml["EnvironmentVariables"]["PATH"] = if xml["EnvironmentVariables"].key?("PATH")
        "#{HOMEBREW_PREFIX}/bin:#{xml["EnvironmentVariables"]["PATH"]}"
      else
        "#{HOMEBREW_PREFIX}/bin"
      end

      xml["EnvironmentVariables"]["HOMEBREW_PREFIX"] = HOMEBREW_PREFIX.to_s

      new_plist_file = "/tmp/#{File.basename(plist_file)}"
      File.write(new_plist_file, xml.to_plist)
      system_command! "plutil",
                      args: ["-lint", new_plist_file]

      system_command! "mv",
                      args: [new_plist_file, plist_file],
                      sudo: true
      system_command! "chown",
                      args: ["root:wheel", "plist_file"],
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

      sudo launchctl load -w com.saltstack.salt.api
      sudo launchctl load -w com.saltstack.salt.master
      sudo launchctl load -w com.saltstack.salt.minion
      sudo launchctl load -w com.saltstack.salt.syndic
    CAVEATS
  end
end
