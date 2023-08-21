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
    url "https://repo.saltproject.io/salt/py3/macos/"
    regex(%r{(\d+(?:\.\d+)?(?:-\d+)?)/})
  end

  conflicts_with formula: "salt"

  pkg "salt-#{version}-py3-#{arch}.pkg"

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
