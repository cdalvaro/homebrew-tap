cask "salt" do
  arch arm: "arm64", intel: "x86_64"

  version "3007.4"

  on_macos do
    sha256 arm:   "88e8d237e84dee0e05418e1f01e4125b44c408fd9ac49e90ff8d6928c3c53183",
           intel: "7f625c72c994e576a4624616f98bb5e33b99b305de9ecadf29c6866a8627ce4a"
  end

  on_linux do
    sha256 :no_check
  end

  url "https://packages.broadcom.com/artifactory/saltproject-generic/macos/#{version}/salt-#{version}-py3-#{arch}.pkg",
      verified: "packages.broadcom.com/artifactory/saltproject-generic/"
  name "Salt #{version} STS"
  desc "Automation and infrastructure management engine"
  homepage "https://saltproject.io/"

  livecheck do
    url "https://packages.broadcom.com/artifactory/saltproject-generic/macos"
    regex(%r{href="\d+\.\d+/">(\d+\.\d+)}i)
  end

  conflicts_with formula: "salt"
  depends_on macos: ">= :big_sur"

  pkg "salt-#{version}-py3-#{arch}.pkg"

  postflight do
    require_relative "../lib/patches/salt"
    %w[api master minion syndic].each { |daemon| Patches::Salt.patch_plist(daemon) }
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
